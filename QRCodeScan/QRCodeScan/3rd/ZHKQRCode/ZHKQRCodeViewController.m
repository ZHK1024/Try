//
//  ZHKQRCodeViewController.m
//  QRCode
//
//  Created by ZHK on 2017/2/23.
//  Copyright © 2017年 Weiyu. All rights reserved.
//

#import "ZHKQRCodeViewController.h"


@interface ZHKQRCodeViewController () 

@property (nonatomic, strong) UIImageView   *rimView;      // 扫描识别边框
@property (nonatomic, strong) UIImageView   *lineView;     // 扫描动画线
@property (nonatomic, strong) UIView        *coverView;    // (框 / 扫描线)层
@property (nonatomic, strong) UIView        *graphicView;  // 图像层(摄像头拍摄下的场景显示)
@property (nonatomic, strong) CADisplayLink *displayLink;

@end

@implementation ZHKQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.rimView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scan_x_ray"]];
    self.lineView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scan_GridLine"]];

    self.coverView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.graphicView = [[UIView alloc] initWithFrame:self.view.bounds];

    [self.view addSubview:self.graphicView];
    [self.view addSubview:self.coverView];

    [self.coverView addSubview:_rimView];
    _rimView.center = self.view.center;

    [self start];

    [self startAnimation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [self.layer removeFromSuperlayer];
    self.layer = nil;
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self stopRunning];
    [self stopAnimation];
}

#pragma mark - Settings

- (void)start {
    // 创建捕捉回话
    self.session = [[AVCaptureSession alloc] init];
    
    // 添加输入设备(数据从摄像头输入)
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [[AVCaptureDeviceInput alloc] initWithDevice:device error:nil];
    if (!input) {
        return;
    }
    [_session addInput:input];
    
    // 添加输出数据
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    if ([_session canAddOutput:output]) {
        [_session addOutput:output];
    }
    
    // 设置输入源数据类型(此处为二维码)
    if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode]) {
        [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    }

    CGFloat x = _rimView.frame.origin.x;
    CGFloat y = _rimView.frame.origin.y;
    CGFloat w = _rimView.frame.size.width;
    CGFloat h = _rimView.frame.size.height;
    CGFloat sw = self.coverView.frame.size.width;
    CGFloat sh = self.coverView.frame.size.height;
    
    // 设置有效采集区域(x/y/w/h/均为反序)
    output.rectOfInterest = CGRectMake(y / sh, x / sw, h / sh, w / sw);
    
    // 添加扫描图层
    self.layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _layer.frame = self.view.bounds;
    [self.graphicView.layer addSublayer:_layer];
    
    [_session startRunning];
}

- (void)stopRunning {
    [self.session stopRunning];
    self.session = nil;
}

#pragma mark - Animation

- (void)startAnimation {
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(animation)];
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    [self.coverView addSubview:self.lineView];
    _lineView.center = CGPointMake(self.view.bounds.size.width / 2, -CGRectGetHeight(_lineView.bounds) / 2);
}

- (void)animation {
    if (CGRectGetMinY(_lineView.frame) >= CGRectGetMaxY(self.view.frame)) {
        _lineView.center = CGPointMake(CGRectGetMidX(_rimView.frame), - CGRectGetHeight(_lineView.frame));
    } else {
        CGPoint center = _lineView.center;
        _lineView.center = CGPointMake(center.x, center.y += 5);
    }
}

- (void)stopAnimation {
    [_displayLink invalidate];
    [_lineView removeFromSuperview];
    self.displayLink = nil;
}

#pragma mark - AVCaptureMetadataOutputObjects delegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *object = [metadataObjects lastObject];
        [self qrcodeScanSuccessWithMessage:object.stringValue];
        // 停止扫描
        [self stopRunning];
        [self stopAnimation];
    } else {
        [self qrcodeScanSuccessWithMessage:nil];
    }
}

#pragma mark - 

- (void)qrcodeScanSuccessWithMessage:(NSString *)message {
    NSLog(@"message = %@", message);
}


@end
