//
//  AZZUserActionsTableViewCell.m
//  LogoDetector
//
//  Created by 朱安智 on 2017/3/20.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import "AZZUserActionsTableViewCell.h"

#import <Masonry/Masonry.h>

@interface AZZUserActionsTableViewCell ()

@property (nonatomic, strong) UIImageView *imgLeft;
@property (nonatomic, strong) UILabel *lbLeft;
@property (nonatomic, strong) UILabel *lbRight;

@end

@implementation AZZUserActionsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (AZZUserActionsTableViewCell *)cellWithTableView:(UITableView *)tableView image:(UIImage *)image title:(NSString *)title detail:(NSString *)detail {
    AZZUserActionsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self.class)];
    if (!cell) {
        cell = [[AZZUserActionsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(self.class)];
    }
    [cell setupSubviews];
    cell.imgLeft.image = image;
    cell.lbLeft.text = title;
    cell.lbRight.text = detail;
    return cell;
}

- (void)setupSubviews {
    [self.imgLeft mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.imgLeft.mas_width);
        make.left.equalTo(self.contentView).with.offset(8);
        make.centerY.equalTo(self.contentView);
        make.top.greaterThanOrEqualTo(self.contentView).with.offset(5);
    }];
    [self.lbLeft mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgLeft.mas_right).with.offset(8);
        make.centerY.equalTo(self.contentView);
    }];
    [self.lbRight mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).with.offset(-8);
        make.centerY.equalTo(self.contentView);
    }];
}

#pragma mark -

- (UIImageView *)imgLeft {
    if (!_imgLeft) {
        _imgLeft = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imgLeft.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_imgLeft];
    }
    return _imgLeft;
}

- (UILabel *)lbLeft {
    if (!_lbLeft) {
        _lbLeft = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbLeft.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_lbLeft];
    }
    return _lbLeft;
}

- (UILabel *)lbRight {
    if (!_lbRight) {
        _lbRight = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbRight.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_lbRight];
    }
    return _lbRight;
}

@end
