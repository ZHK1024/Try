//
//  ZHKWiFiServer.m
//  WiFFServer
//
//  Created by ZHK on 2018/7/5.
//  Copyright © 2018年 ZHK. All rights reserved.
//

#import "ZHKWiFiServer.h"
#import "NSString+URL.h"
#import <GCDWebServer.h>
#import <GCDWebServerDataResponse.h>
#import <GCDWebServerFileRequest.h>

@interface ZHKWiFiServer ()

@property (nonatomic, strong) GCDWebServer *server;

@end

@implementation ZHKWiFiServer

#pragma mark - Init

+ (instancetype)server:(id<WiFiServerDelegate>)delegate {
    return [[self alloc] initWithDelegate:delegate];
}

- (instancetype)initWithDelegate:(id <WiFiServerDelegate>)delegate {
    if (self = [super init]) {
        self.server = [[GCDWebServer alloc] init];
        self.delegate = delegate;
    }
    return self;
}

#pragma mark - Public

- (void)start {
    [self registService];
    [_server startWithPort:8080 bonjourName:@""];
}

- (void)stop {
    [_server stop];
}

- (NSURL *)serverURL {
    return _server.serverURL;
}

#pragma mark - Private

/**
 注册服务
 */
- (void)registService {
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

                        if ([ws.delegate respondsToSelector:@selector(fileReceive:data:name:)]) {
                            [ws.delegate fileReceive:ws data:data name:fileName];
                        }
                        return [GCDWebServerDataResponse responseWithHTML:@"ok"];
                    }];
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

@end
