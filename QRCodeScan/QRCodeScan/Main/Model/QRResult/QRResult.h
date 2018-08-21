//
//  QRResult.h
//  QRCodeScan
//
//  Created by ZHK on 2018/7/26.
//  Copyright © 2018年 ZHK. All rights reserved.
//

#import <Realm/Realm.h>

@interface QRResult : RLMObject

@property NSString *uuid;
@property NSString *name;
@property NSString *content;
@property NSString *logo;
@property NSDate   *date;

@end
