//
//  QRHistoryViewCell.h
//  QRCodeScan
//
//  Created by ZHK on 2018/7/26.
//  Copyright © 2018年 ZHK. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const QRHistoryViewCell_IDFR;

@class QRResult;
@interface QRHistoryViewCell : UITableViewCell

@property (nonatomic, strong) QRResult *QRinfo;

@end
