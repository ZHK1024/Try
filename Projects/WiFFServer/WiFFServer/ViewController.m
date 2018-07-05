//
//  ViewController.m
//  WiFFServer
//
//  Created by ZHK on 2018/2/12.
//  Copyright © 2018年 ZHK. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+QRCode.h"
#import <GCDWebServer.h>
#import <GCDWebServerDataResponse.h>
#import <GCDWebServerFileRequest.h>
#import <GCDWebServerURLEncodedFormRequest.h>
#import <GCDWebServerMultiPartFormRequest.h>
#import <GCDWebServerFileResponse.h>
#import <Social/Social.h>

@interface ViewController ()

@property (nonatomic, strong) GCDWebServer *server;
@property (weak, nonatomic) IBOutlet UIImageView *QRView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.server = [[GCDWebServer alloc] init];
 
    
//    [_server addDefaultHandlerForMethod:@"GET"
//                           requestClass:[GCDWebServerRequest class]
//                           processBlock:^GCDWebServerResponse * _Nullable(__kindof GCDWebServerRequest * _Nonnull request) {
//        return [GCDWebServerDataResponse responseWithHTML:@"hello word"];
//    }];
    
    __weak typeof(self) ws = self;
//    [_server addDefaultHandlerForMethod:@"GET"
//
//                           requestClass:[GCDWebServerRequest class]
//                           processBlock:^GCDWebServerResponse * _Nullable(__kindof GCDWebServerRequest * _Nonnull request) {
//        request;
//        return [GCDWebServerDataResponse responseWithHTML:[ws html]];
//    }];
    
    [_server addHandlerForMethod:@"GET"
                            path:@"/upload.html"
                    requestClass:[GCDWebServerRequest class]
                    processBlock:^GCDWebServerResponse * _Nullable(__kindof GCDWebServerRequest * _Nonnull request) {
                        
        return [GCDWebServerDataResponse responseWithHTML:[ws html]];
    }];
    
    [_server addHandlerForMethod:@"POST"
                            path:@"/uploadfile"
                    requestClass:[GCDWebServerFileRequest class] processBlock:^GCDWebServerResponse * _Nullable(__kindof GCDWebServerFileRequest * _Nonnull request) {

//                        NSLog(@"aaurl = %@", request.URL.absoluteString);
                        
                        NSData *data = [NSData dataWithContentsOfFile:request.temporaryPath];
                        
                        NSString *query = request.URL.query;
                        NSString *fileName = nil;
                        
                        @try {
                            NSArray *attributes = [query componentsSeparatedByString:@"&"];
                            if (attributes.count > 0) {
                                NSString *attribute = attributes.firstObject;
                                NSArray *kvs = [attribute componentsSeparatedByString:@"="];
                                fileName = [kvs lastObject];
                                fileName = [ws decodeFromPercentEscapeString:fileName];
                            }
                        } @catch (NSException *exception) {
                            
                        }
                        if (fileName.length == 0) {
                            fileName = [NSString stringWithFormat:@"%.0f", CFAbsoluteTimeGetCurrent()];
                        }
                        
                        NSString *path = [ws filePath];
                        path = [path stringByAppendingPathComponent:fileName];
                        NSLog(@"path = %@", path);
                        [data writeToFile:path atomically:YES];
                        
//                        NSLog(@"headers = %@  \n%@    \n%@    %d   %@", request.headers, request.contentType, request.temporaryPath, request.hasBody, request.URL.query);
                        
        return [GCDWebServerDataResponse responseWithHTML:@"ok"];
    }];
    
//    [_server addHandlerForMethod:@"GET"
//                            path:@"/download.html"
//                    requestClass:[GCDWebServerFileRequest class] processBlock:^GCDWebServerResponse * _Nullable(__kindof GCDWebServerRequest * _Nonnull request) {
//
//                        NSString *path = [[NSBundle mainBundle] pathForResource:@"1510648457" ofType:@"zbk"];
//                        return [GCDWebServerFileResponse responseWithFile:path];
//    }];
    
    [_server startWithPort:8080 bonjourName:@""];
    
    _QRView.image = [UIImage QRCodeWithCodeText:_server.serverURL.absoluteString imageSize:600];
}

// 解编码
- (NSString *)decodeFromPercentEscapeString:(NSString *)input {
    NSMutableString *outputStr = [NSMutableString stringWithString:input];
    [outputStr replaceOccurrencesOfString:@"+"
                               withString:@" "
                                  options:NSLiteralSearch
                                    range:NSMakeRange(0, [outputStr length])];
    return [outputStr stringByRemovingPercentEncoding];
}

// 替换模板中 host
- (NSString *)html {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"upload" ofType:@"html"];
    NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSString *url = [NSString stringWithFormat:@"%@uploadfile", _server.serverURL.absoluteString];
    return [html stringByReplacingOccurrencesOfString:@"$uploadurl" withString:url];
}

// 文件存放路径
- (NSString *)filePath {
    NSString *document = [NSString stringWithFormat:@"/Library/wifiFiles"];
    NSString *documentPath = [NSHomeDirectory() stringByAppendingPathComponent:document];
    BOOL isDirectory;
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentPath isDirectory:&isDirectory]) {
        NSError *error;
        BOOL result = [[NSFileManager defaultManager] createDirectoryAtPath:documentPath withIntermediateDirectories:NO attributes:nil error:&error];
        if (result) {
            NSLog(@"Create document success!");
        } else {
            NSLog(@"Error: %@", error);
        }
    }
    return documentPath;
}

// 分享按钮
- (IBAction)showSharePinal:(UIButton *)sender {
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[[_server.serverURL URLByAppendingPathComponent:@"upload.html"]] applicationActivities:nil];
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -

- (NSString *)formatZeroAtEndWithString:(NSString *)string {
    if (string.length >= 6) {
        return string;
    }
    NSString *formatter = [NSString stringWithFormat:@"%%0%ldld", 6 - string.length];
    NSString *result = [NSString stringWithFormat:formatter, 0];
    return [NSString stringWithFormat:@"%@%@", string, result];
}

@end
