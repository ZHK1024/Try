//
//  QRResult.m
//  QRCodeScan
//
//  Created by ZHK on 2018/7/26.
//  Copyright © 2018年 ZHK. All rights reserved.
//

#import "QRResult.h"

@implementation QRResult

+ (NSString *)primaryKey {
    return @"uuid";
}

+ (NSDictionary *)defaultPropertyValues {
    return @{@"uuid" : [NSUUID UUID].UUIDString,
             @"date" : [NSDate date]
             };
}

@end
