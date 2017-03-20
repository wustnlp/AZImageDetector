//
//  AZZCenterTitleButton.m
//  LogoDetector
//
//  Created by 朱安智 on 2017/3/17.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import "AZZCenterTitleButton.h"

#import <Masonry/Masonry.h>

@interface AZZCenterTitleButton ()

@property (nonatomic, strong) UIImageView *imgBackground;
@property (nonatomic, strong) UILabel *lbTitle;

@end

@implementation AZZCenterTitleButton

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [self.imgBackground mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.lbTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}

- (UIImageView *)imgBackground {
    if (!_imgBackground) {
        _imgBackground = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imgBackground.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_imgBackground];
    }
    return _imgBackground;
}

- (UILabel *)lbTitle {
    if (!_lbTitle) {
        _lbTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:_lbTitle];
    }
    return _lbTitle;
}

@end
