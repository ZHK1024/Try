//
//  ZHKQRCodeViewController.h
//  QRCode
//
//  Created by ZHK on 2017/2/23.
//  Copyright © 2017年 Weiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol ZHKQRCodeDelegate <NSObject>

@required
// 扫描完成回调
- (void)qrcodeScanSuccessWithMessage:(NSString *)message;

@end

@interface ZHKQRCodeViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate, ZHKQRCodeDelegate>

@property (nonatomic, strong) AVCaptureSession           *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *layer;

@end
