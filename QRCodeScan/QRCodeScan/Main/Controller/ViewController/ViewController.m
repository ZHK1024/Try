//
//  ViewController.m
//  QRCodeScan
//
//  Created by ZHK on 2018/7/26.
//  Copyright © 2018年 ZHK. All rights reserved.
//

#import "ViewController.h"
#import "QRHistoryViewCell.h"
#import "QRResultViewController.h"
#import "WKWebViewController.h"
#import <Realm.h>
#import "QRResult.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) RLMResults *history;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
    [_tableView reloadData];
}

#pragma mark - UI

- (void)setupUI {
    self.title = @"扫描历史";
    [_tableView registerClass:[QRHistoryViewCell class] forCellReuseIdentifier:QRHistoryViewCell_IDFR];
}

#pragma mark - Data

- (void)loadData {
    self.history = [[QRResult allObjects] sortedResultsUsingKeyPath:@"date" ascending:NO];
}

#pragma mark - UITableView dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _history.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QRHistoryViewCell *cell = [tableView dequeueReusableCellWithIdentifier:QRHistoryViewCell_IDFR];
    cell.QRinfo = _history[indexPath.row];
    return cell;
}

#pragma mark - UITableView delegate

// row select
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    QRResultViewController *resultVC = [[QRResultViewController alloc] init];
    resultVC.res = _history[indexPath.row];
    [self.navigationController pushViewController:resultVC animated:YES];
    
//    QRResult *res = _history[indexPath.row];
//    WKWebViewController *wkwebVC = [[WKWebViewController alloc] init];
//    wkwebVC.url = [NSURL URLWithString:res.url];
//    [self.navigationController pushViewController:wkwebVC animated:YES];
}

// row heighr
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0;
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

#pragma mark - UITableView edit

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        QRResult *res = _history[indexPath.row];
        [res.realm transactionWithBlock:^{
            [res.realm deleteObject:res];
        }];
        [self loadData];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

@end
