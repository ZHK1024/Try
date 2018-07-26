//
//  UIImage+QRCode.m
//  QRCode
//
//  Created by ZHK on 2017/2/23.
//  Copyright © 2017年 Weiyu. All rights reserved.
//

#import "UIImage+QRCode.h"

@implementation UIImage (QRCode)

/**
 获取图片二维码信息
 
 @return 信息
 */
- (NSString *)QRCodeMessgae {
    // 0.创建上下文
    CIContext *context = [[CIContext alloc] init];
    
    // 1.创建一个探测器
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:context options:@{CIDetectorAccuracy: CIDetectorAccuracyLow}];
    
    // 2.直接开始识别图片,获取图片特征
    CIImage *imageCI = [[CIImage alloc] initWithImage:self];
    NSArray<CIFeature *> *features = [detector featuresInImage:imageCI];
    CIQRCodeFeature *codef = (CIQRCodeFeature *)features.firstObject;
    
    return codef.messageString;
}

/**
 根据字符串获取二维码
 
 @param text 需要转换的字符串
 @param size 图片尺寸
 @return  Image
 */
+ (UIImage *)QRCodeWithCodeText:(NSString *)text imageSize:(CGFloat)size {
    CIImage *image = [self createQRCodeWithText:text];
    return [self createUIImageWithCIImage:image imageSize:size];
}

#pragma mark - 

/**
 根据字符串创建二维码
 
 @param text 字符串
 @return 二维码
 */
+ (CIImage *)createQRCodeWithText:(NSString *)text {
    // 创建过滤器
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 恢复默认
    [filter setDefaults];
    // 给过滤器添加数据
    NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    // 获取二维码, 并返回
    return [filter outputImage];
}

/**
 将 CIImage 转换为制定尺寸的 UIImage
 
 @param image CIImage
 @param size  指定的尺寸
 @return  UIImage 结果
 */
+ (UIImage *)createUIImageWithCIImage:(CIImage *)image imageSize:(CGFloat)size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size / CGRectGetWidth(extent), size / CGRectGetHeight(extent));
    
    // 创建 bitmap
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef imageRef = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, imageRef);
    
    // 保存 bitmap 到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(imageRef);
    
    return [UIImage imageWithCGImage:scaledImage];
}

@end
