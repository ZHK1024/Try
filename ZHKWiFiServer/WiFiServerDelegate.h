//
//  ZHKWiFiServerDelegate.h
//  WiFFServer
//
//  Created by ZHK on 2018/7/5.
//Copyright © 2018年 ZHK. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZHKWiFiServer;
@protocol WiFiServerDelegate <NSObject>

- (void)fileReceive:(ZHKWiFiServer *)server data:(NSData *)data name:(NSString *)name;

@end
