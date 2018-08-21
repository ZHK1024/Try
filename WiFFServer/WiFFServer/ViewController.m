//
//  ViewController.m
//  WiFFServer
//
//  Created by ZHK on 2018/2/12.
//  Copyright © 2018年 ZHK. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+QRCode.h"
#import <Social/Social.h>
#import "NSString+URL.h"

#import "ZHKWiFiServer.h"

@interface ViewController () <WiFiServerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *QRView;

@property (nonatomic, strong) ZHKWiFiServer *server;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.server = [ZHKWiFiServer server:self];
    [_server start];
    
    _QRView.image = [UIImage QRCodeWithCodeText:_server.serverURL.absoluteString imageSize:600];
}

#pragma mark - WiFiServer delegate

- (BOOL)fileReceive:(ZHKWiFiServer *)server temporaryPath:(NSString *)temporaryPath name:(NSString *)name {
    NSString *path = [self filePathWithFileName:name];
    NSInteger count = 0;
    while ([[NSFileManager defaultManager] fileExistsAtPath:path] == YES) {
        count++;
        NSArray *components = [name componentsSeparatedByString:@"."];
        NSString *fileName = components[0];
        if (components.count == 2) {
            NSString *fileExtn = components[1];
            path = [self filePathWithFileName:[NSString stringWithFormat:@"%@ %ld.%@", fileName, count, fileExtn]];
            continue;
        }
        path = [self filePathWithFileName:[NSString stringWithFormat:@"%@ %ld", fileName, count]];
    }
    NSError *error = nil;
    BOOL res = [[NSFileManager defaultManager] moveItemAtPath:temporaryPath toPath:path error:&error];
    if (error) {
        NSLog(@"error: %@", error);
    }
    
    return res;
}

- (NSString *)filePathWithFileName:(NSString *)fileName {
    return [[self filePath] stringByAppendingPathComponent:fileName];
}

#pragma mark -

// 文件存放路径
- (NSString *)filePath {
    NSString *document = @"/Library/wifiFiles";
    NSString *documentPath = [NSHomeDirectory() stringByAppendingPathComponent:document];
    BOOL isDirectory;
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentPath isDirectory:&isDirectory]) {
        NSError *error;
        BOOL result = [[NSFileManager defaultManager] createDirectoryAtPath:documentPath withIntermediateDirectories:NO attributes:nil error:&error];
        if (result) {
            NSLog(@"Create document success!");
        } else {
            NSLog(@"Error: %@", error);
        }
    }
    return documentPath;
}

// 分享链接
- (IBAction)showSharePinal:(UIButton *)sender {
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[[_server.serverURL URLByAppendingPathComponent:@"upload.html"]] applicationActivities:nil];
    [self presentViewController:activityVC animated:YES completion:nil];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
- (NSString *)formatZeroAtEndWithString:(NSString *)string {
    if (string.length >= 6) {
        return string;
    }
    NSString *formatter = [NSString stringWithFormat:@"%%0%ldld", 6 - string.length];
    NSString *result = [NSString stringWithFormat:formatter, 0];
    return [NSString stringWithFormat:@"%@%@", string, result];
}
 */

@end
