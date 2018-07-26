//
//  QRResultViewController.m
//  QRCodeScan
//
//  Created by ZHK on 2018/7/26.
//  Copyright © 2018年 ZHK. All rights reserved.
//

#import "QRResultViewController.h"
#import "QRResult.h"
#import <Masonry.h>
#import <ReactiveObjC.h>

@interface QRResultViewController ()

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UITextView  *textView;
@property (nonatomic, strong) UIView      *backView;

@end

@implementation QRResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UI

- (void)setupUI {
    RAC(self, title) = RACObserve(_res, name);
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"more"] style:UIBarButtonItemStyleDone target:self action:@selector(moreAction)];
    
    [self.view addSubview:self.textField];
    [self.view addSubview:self.backView];
    [_backView addSubview:self.textView];
    
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15.0f);
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.height.mas_equalTo(35.0f);
    }];
    
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_textField);
        make.top.equalTo(_textField.mas_bottom).offset(10.0f);
        make.bottom.mas_equalTo(-15.0f);
    }];
    
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 10, 10, 10));
    }];


    [[[_textField rac_signalForControlEvents:UIControlEventEditingDidEnd] filter:^BOOL(__kindof UIControl * _Nullable value) {
        return ![_textField.text isEqualToString:_res.name];
    }] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [_res.realm beginWriteTransaction];
        [_res setName:_textField.text];
        [_res.realm commitWriteTransaction];
    }];
}

#pragma mark - Action

- (void)moreAction {
    NSURL *url = [NSURL URLWithString:_res.url];
    if (url) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
            
        }];
    }
}

#pragma mark - Getter

- (UITextField *)textField {
    if (_textField == nil) {
        self.textField = [UITextField new];
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        _textField.text = _res.name;
    }
    return _textField;
}

- (UITextView *)textView {
    if (_textView == nil) {
        self.textView = [UITextView new];
        _textView.editable = NO;
        _textView.text  = _res.url;
    }
    return _textView;
}

- (UIView *)backView {
    if (_backView == nil) {
        self.backView = [UIView new];
        _backView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.1];
    }
    return _backView;
}

@end
