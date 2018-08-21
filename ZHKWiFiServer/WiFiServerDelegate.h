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

- (BOOL)fileReceive:(ZHKWiFiServer *)server temporaryPath:(NSString *)temporaryPath name:(NSString *)name;

@end
