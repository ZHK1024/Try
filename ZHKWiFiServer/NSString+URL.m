//
//  NSString+URL.m
//  WiFFServer
//
//  Created by ZHK on 2018/7/5.
//Copyright © 2018年 ZHK. All rights reserved.
//

#import "NSString+URL.h"

@implementation NSString (URL)

- (NSDictionary *)paramsFromQuery {
    if (self.length == 0) {
        return @{};
    }
    NSArray *keyValues = [self componentsSeparatedByString:@"&"];
    if (keyValues.count == 0) {
        return @{};
    }
    NSMutableDictionary *temp = [NSMutableDictionary new];
    for (NSString *kv in keyValues) {
        NSArray *param = [kv componentsSeparatedByString:@"="];
        if (param.count == 2) {
            [temp setValue:param.lastObject forKey:param.firstObject];
        }
    }
    return temp;
}

@end
