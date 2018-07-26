//
//  QRHistoryViewCell.m
//  QRCodeScan
//
//  Created by ZHK on 2018/7/26.
//  Copyright © 2018年 ZHK. All rights reserved.
//

#import "QRHistoryViewCell.h"
#import "QRResult.h"
#import <Masonry.h>

NSString *const QRHistoryViewCell_IDFR = @"QRHistoryViewCell";

@interface QRHistoryViewCell ()

@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) UILabel     *nameLabel;
@property (nonatomic, strong) UILabel     *contentLabel;
@property (nonatomic, strong) UILabel     *dateLabel;

@end

@implementation QRHistoryViewCell

#pragma mark - Init

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

#pragma mark - UI

- (void)createUI {
    [self.contentView addSubview:self.logoView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.dateLabel];
    
    [_logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(40.0f, 40.0f));
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15.0f);
        make.left.equalTo(_logoView.mas_right).offset(10.0f);
        make.right.equalTo(_dateLabel.mas_left).offset(-10.0f);
    }];
    
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.0f);
        make.centerY.equalTo(_nameLabel);
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel);
        make.right.equalTo(_dateLabel);
        make.bottom.mas_equalTo(-15.0f);
    }];
}

#pragma mark - Setter

- (void)setQRinfo:(QRResult *)QRinfo {
    if (_QRinfo != QRinfo) {
        _QRinfo = QRinfo;
        _nameLabel.text = _QRinfo.name;
        _contentLabel.text = _QRinfo.url;
        _dateLabel.text = ({
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yy-MM-dd HH:mm";
            [formatter stringFromDate:QRinfo.date];
        });
        
        if (QRinfo.logo == nil) {
            _logoView.image = [UIImage imageNamed:@"default_logo"];
        }
    }
}

#pragma mark - Getter

- (UIImageView *)logoView {
    if (_logoView == nil) {
        self.logoView = [UIImageView new];
    }
    return _logoView;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        self.nameLabel = [UILabel new];
        _nameLabel.font = [UIFont systemFontOfSize:15.0f];
        _nameLabel.textColor = [UIColor darkGrayColor];
    }
    return _nameLabel;
}

- (UILabel *)contentLabel {
    if (_contentLabel == nil) {
        self.contentLabel = [UILabel new];
        _contentLabel.font = [UIFont systemFontOfSize:12.0f];
        _contentLabel.textColor = [[UIColor grayColor] colorWithAlphaComponent:0.8];
    }
    return _contentLabel;
}

- (UILabel *)dateLabel {
    if (_dateLabel == nil) {
        self.dateLabel = [UILabel new];
        _dateLabel.font = [UIFont systemFontOfSize:12.0f];
        _dateLabel.textColor = [[UIColor grayColor] colorWithAlphaComponent:0.8];
    }
    return _dateLabel;
}

@end
