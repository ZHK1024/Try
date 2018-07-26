//
//  QRCodeViewController.m
//  QRCodeScan
//
//  Created by ZHK on 2018/7/26.
//  Copyright © 2018年 ZHK. All rights reserved.
//

#import "QRCodeViewController.h"
#import "WKWebViewController.h"
#import "QRResult.h"

@interface QRCodeViewController ()

@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"扫描二维码";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -

- (void)qrcodeScanSuccessWithMessage:(NSString *)message {
    
    QRResult *res = [[QRResult alloc] init];
    res.url  = message;
    res.name = message;
    
    NSURL *url = [NSURL URLWithString:message];
    if (url) {
        WKWebViewController *wkwebView = [[WKWebViewController alloc] init];
        wkwebView.url = url;
        wkwebView.res = res;
        [self.navigationController pushViewController:wkwebView animated:YES];
        
        res.name = @"URL";
    } else {
        res.name = @"Text";
    }
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        [realm addOrUpdateObject:res];
    }];
    
    
}

@end
