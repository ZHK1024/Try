//
//  WKWebViewController.m
//  QRCodeScan
//
//  Created by ZHK on 2018/7/26.
//  Copyright © 2018年 ZHK. All rights reserved.
//

#import "WKWebViewController.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "QRResult.h"

@interface WKWebViewController () <WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation WKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UI

- (void)setupUI {
    self.title = @"网页";
    [self.view addSubview:self.webView];
    NSURLRequest *request = [NSURLRequest requestWithURL:_url];
    [_webView loadRequest:request];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"more"] style:UIBarButtonItemStyleDone target:self action:@selector(moreAction)];
}

#pragma mark -

- (void)moreAction {
    
}

#pragma mark -

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    NSString *title = webView.title;
    if (title.length > 0) {
        self.title = title;
        [_res.realm beginWriteTransaction];
        [_res setName:title];
        [_res.realm commitWriteTransaction];
    }
}

#pragma mark - Getter

- (WKWebView *)webView {
    if (_webView == nil) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
        _webView.navigationDelegate = self;
    }
    return _webView;
}

@end
