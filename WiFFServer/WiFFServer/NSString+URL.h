//
//  NSString+URL.h
//  WiFFServer
//
//  Created by ZHK on 2018/7/5.
//Copyright © 2018年 ZHK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URL)

/**
 从 query 中获取参数

 @return 参数字典
 */
- (NSDictionary *)paramsFromQuery;

@end
