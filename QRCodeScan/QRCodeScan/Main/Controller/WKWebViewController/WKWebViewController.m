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
#import <Masonry.h>
#import <ReactiveObjC.h>
#import <Social/Social.h>
#import "QRResult.h"

@interface WKWebViewController () <WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UIToolbar *tooBar;

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
    [self.view addSubview:self.progressView];
    [self.view addSubview:self.tooBar];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:_url];
    [_webView loadRequest:request];
    
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(_webView);
        make.height.mas_equalTo(2.0f);
    }];
    
    [_tooBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0.0f);
        make.height.mas_equalTo(50.0f);
    }];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"more"] style:UIBarButtonItemStyleDone target:self action:@selector(moreAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(moreAction)];
    
    
    [RACObserve(_webView, estimatedProgress) subscribeNext:^(NSNumber   * _Nullable x) {
        [_progressView setProgress:x.doubleValue animated:YES];
    }];
}

#pragma mark - Action

- (void)moreAction {
    [_progressView setProgress:0 animated:NO];
    [_webView reload];
}

- (void)goBackAction {
    [_webView goBack];
}

- (void)goForwordAction {
    [_webView goForward];
}

- (void)shareAction {
    if (_url == nil) {
        return;
    }
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[_url] applicationActivities:nil];
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (void)openWithSafari {
    if (_url) {
        [[UIApplication sharedApplication] openURL:_url options:@{} completionHandler:nil];
    }
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
    [_progressView setProgress:1 animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_progressView setProgress:0 animated:NO];
    });
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

- (UIProgressView *)progressView {
    if (_progressView == nil) {
        self.progressView = [[UIProgressView alloc] init];
        _progressView.trackTintColor = [UIColor clearColor];
    }
    return _progressView;
}

- (UIToolbar *)tooBar {
    if (_tooBar == nil) {
        self.tooBar = [[UIToolbar alloc] init];
        
        UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(goBackAction)];
        UIBarButtonItem *forward = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(goForwordAction)];
        UIBarButtonItem *share = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(shareAction)];
        UIBarButtonItem *open = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRedo target:self action:@selector(openWithSafari)];
        
        RAC(back, enabled) = RACObserve(_webView, canGoBack);
        RAC(forward, enabled) = RACObserve(_webView, canGoForward);
        
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        _tooBar.items = @[back, space, forward, space, share, space, open];
    }
    return _tooBar;
}

@end
