//
//  AZZLocationView.m
//  LogoDetector
//
//  Created by 朱安智 on 2017/3/31.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import "AZZLocationView.h"
#import "AZZLocationManager.h"

#import <Masonry/Masonry.h>

@interface AZZLocationView ()

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *lbLocation;

@end

@implementation AZZLocationView

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    [self updateLocation];
    [self setupConstraints];
}

- (void)updateLocation {
    [AZZLocationManagerInstance getCurrentPlacemarksWithBlock:^(NSArray<CLPlacemark *> *placeMarks) {
        self.lbLocation.text = [placeMarks firstObject].name;
        [self setNeedsLayout];
    }];
}

- (void)setupConstraints {
    self.backgroundColor = [UIColor colorWithRed:0.584 green:0.651 blue:0.804 alpha:0.500];
    [self.icon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.right.equalTo(self.lbLocation.mas_left).with.offset(-5);
        make.centerY.equalTo(self);
        make.left.equalTo(self).with.offset(5);
    }];
    [self.lbLocation mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.right.equalTo(self).with.offset(-5);
    }];
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"u165"]];
        _icon.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_icon];
    }
    return _icon;
}

- (UILabel *)lbLocation {
    if (!_lbLocation) {
        _lbLocation = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbLocation.textColor = [UIColor whiteColor];
        _lbLocation.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_lbLocation];
    }
    return _lbLocation;
}

@end
