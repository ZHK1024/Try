//
//  WKWebViewController.h
//  QRCodeScan
//
//  Created by ZHK on 2018/7/26.
//  Copyright © 2018年 ZHK. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QRResult;
@interface WKWebViewController : UIViewController

@property (nonatomic, strong) NSURL    *url;
@property (nonatomic, strong) QRResult *res;

@end
