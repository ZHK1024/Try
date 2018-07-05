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
#import "NSString+URL.h"

@interface ViewController ()

@property (nonatomic, strong) GCDWebServer *server;
@property (weak, nonatomic) IBOutlet UIImageView *QRView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.server = [[GCDWebServer alloc] init];
    
    __weak typeof(self) ws = self;
    
    // 开启上传页面服务
    [_server addHandlerForMethod:@"GET"
                            path:@"/upload.html"
                    requestClass:[GCDWebServerRequest class]
                    processBlock:^GCDWebServerResponse * _Nullable(__kindof GCDWebServerRequest * _Nonnull request) {
                        
        return [GCDWebServerDataResponse responseWithHTML:[ws html]];
    }];
    
    // 开启文件上传服务
    [_server addHandlerForMethod:@"POST"
                            path:@"/uploadfile"
                    requestClass:[GCDWebServerFileRequest class] processBlock:^GCDWebServerResponse * _Nullable(__kindof GCDWebServerFileRequest * _Nonnull request) {
                        
                        NSData *data = [NSData dataWithContentsOfFile:request.temporaryPath];
                        
                        NSDictionary *params = [request.URL.query paramsFromQuery];
                        NSString *fileName = params[@"filename"];
                        
                        if (fileName.length == 0) {
                            fileName = [NSString stringWithFormat:@"%.0f", CFAbsoluteTimeGetCurrent()];
                        } else {
                            fileName = [ws decodeFromPercentEscapeString:fileName];
                        }
                        
                        NSString *path = [ws filePath];
                        path = [path stringByAppendingPathComponent:fileName];
                        [data writeToFile:path atomically:YES];
                        
        return [GCDWebServerDataResponse responseWithHTML:@"ok"];
    }];

    // 开始运行
    [_server startWithPort:8080 bonjourName:@""];
    
    // 生成上传页面 url 的二维码
    _QRView.image = [UIImage QRCodeWithCodeText:_server.serverURL.absoluteString imageSize:600];
}

#pragma mark -

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
    NSString *document = @"/Library/wifiFiles";
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

// 分享链接
- (IBAction)showSharePinal:(UIButton *)sender {
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[[_server.serverURL URLByAppendingPathComponent:@"upload.html"]] applicationActivities:nil];
    [self presentViewController:activityVC animated:YES completion:nil];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
- (NSString *)formatZeroAtEndWithString:(NSString *)string {
    if (string.length >= 6) {
        return string;
    }
    NSString *formatter = [NSString stringWithFormat:@"%%0%ldld", 6 - string.length];
    NSString *result = [NSString stringWithFormat:formatter, 0];
    return [NSString stringWithFormat:@"%@%@", string, result];
}
 */

@end
