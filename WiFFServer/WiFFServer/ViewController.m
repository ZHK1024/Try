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

- (void)fileReceive:(ZHKWiFiServer *)server data:(NSData *)data name:(NSString *)name {
    [data writeToFile:[[self filePath] stringByAppendingPathComponent:name] atomically:YES];
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
