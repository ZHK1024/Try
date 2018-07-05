//
//  FileListViewController.m
//  WiFFServer
//
//  Created by ZHK on 2018/3/14.
//  Copyright © 2018年 ZHK. All rights reserved.
//

#import "FileListViewController.h"

@interface FileListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *list;

@end

@implementation FileListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.list = [self fileLsitFromDocument:[self documentPath]];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UI

- (void)createUI {
    self.title = @"文件列表";
    self.view.backgroundColor = [UIColor whiteColor];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (NSString *)documentPath {
    NSString *document = [NSString stringWithFormat:@"/Library/wifiFiles"];
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

- (NSArray *)fileLsitFromDocument:(NSString *)documentPath {
    NSArray *list = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:[NSURL URLWithString:documentPath] includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsSubdirectoryDescendants error:nil];;
    return list;
}

#pragma mark - UITableView dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSURL *url = _list[indexPath.row];
    NSString *fileName = [[url.absoluteString componentsSeparatedByString:@"/"] lastObject];
    cell.textLabel.text = [fileName stringByRemovingPercentEncoding];
    cell.textLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    return cell;
}

#pragma mark - UITableView delegate

// row select
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// row heighr
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

// header footer height
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

// view for header footer
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}


@end
