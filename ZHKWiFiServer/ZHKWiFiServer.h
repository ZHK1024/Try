//
//  ZHKWiFiServer.h
//  WiFFServer
//
//  Created by ZHK on 2018/7/5.
//  Copyright © 2018年 ZHK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WiFiServerDelegate.h"

@interface ZHKWiFiServer : NSObject

@property (nonatomic, strong, readonly) NSURL *serverURL;
@property (nonatomic, weak) id <WiFiServerDelegate> delegate;

+ (instancetype)server:(id<WiFiServerDelegate>)delegate;

- (void)start;

- (void)stop;

@end
