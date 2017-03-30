//
//  AZZOpenHongBaoView.m
//  LogoDetector
//
//  Created by 朱安智 on 2017/3/30.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import "AZZOpenHongBaoView.h"
#import "AZZHongBaoModel.h"
#import "AZZClient.h"
#import <Masonry/Masonry.h>
#import <MBProgressHUD/MBProgressHUD.h>

#define OpenButtonWidth 80.f
#define SelfSize CGSizeMake(201.f, 270.f)

@interface AZZOpenHongBaoView ()

@property (nonatomic, copy) AZZHongBaoModel *hongbaoModel;
@property (nonatomic, assign) BOOL opened;

@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) UIButton *btnOpen;
@property (nonatomic, strong) UIButton *btnClose;

@property (nonatomic, strong) UIButton *btnKeepLooking;

@property (nonatomic, strong) UIImageView *userIcon;
@property (nonatomic, strong) UILabel *lbUserName;
@property (nonatomic, strong) UILabel *lbMoney;
@property (nonatomic, strong) UILabel *lbYuan;
@property (nonatomic, strong) UILabel *lbResult;
@property (nonatomic, strong) UIImageView *gotBackground;

@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation AZZOpenHongBaoView

+ (instancetype)showInView:(UIView *)view withModel:(AZZHongBaoModel *)model {
    AZZOpenHongBaoView *instance = [[AZZOpenHongBaoView alloc] initWithFrame:CGRectMake(0, 0, SelfSize.width, SelfSize.height)];
    instance.center = CGPointMake(view.bounds.size.width / 2.f, view.bounds.size.height / 2.f);
    instance.alpha = 0.f;
    [view addSubview:instance];
    instance.hongbaoModel = model;
    instance.opened = NO;
    [UIView animateWithDuration:0.5f animations:^{
        instance.alpha = 1;
    }];
    return instance;
}

- (void)showInView:(UIView *)view {
    self.alpha = 0.f;
    self.frame = CGRectMake(0, 0, SelfSize.width, SelfSize.height);
    self.center = CGPointMake(view.bounds.size.width / 2.f, view.bounds.size.height / 2.f);
    [view addSubview:self];
    [UIView animateWithDuration:0.5f
                     animations:^{
                         self.alpha = 1.f;
                     }];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    [self setupConstraints];
}

- (void)setupConstraints {
    [self.backgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.btnOpen mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(127.f);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(90, 90));
    }];
    [self.gotBackground mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.userIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40.f, 40.f));
        make.centerX.equalTo(self);
        make.top.equalTo(self).with.offset(40.f);
    }];
    [self.lbUserName mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.userIcon.mas_bottom).with.offset(5.f);
    }];
    [self.lbMoney mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    [self.lbYuan mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lbMoney.mas_right).with.offset(3);
        make.centerY.equalTo(self.lbMoney);
    }];
    [self.lbResult mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lbMoney.mas_bottom).with.offset(20.f);
        make.centerX.equalTo(self.lbMoney);
    }];
    [self.btnKeepLooking mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(100.f, 30.f));
        make.top.equalTo(self.lbResult.mas_bottom).with.offset(40);
    }];
    [self.btnClose mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(15);
        make.right.equalTo(self).with.offset(-15);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
}

- (void)openSuccess {
    [self.hud hideAnimated:YES];
    self.opened = YES;
    [self showResult];
}

- (void)btnOpenClicked:(UIButton *)button {
    self.hud.mode = MBProgressHUDModeIndeterminate;
    self.hud.label.text = nil;
    self.hud.detailsLabel.text = nil;
    [self.hud showAnimated:YES];
    [AZZClientInstance requestGetHongWithUUID:self.hongbaoModel.idString BaoSuccess:^(NSString * _Nullable msg, id  _Nullable obj) {
        //self.lbHongBao.text = [NSString stringWithFormat:@"还有%@个红包", @(self.hongbaoModel.remainAmount - 1)];
        self.lbMoney.text = [NSString stringWithFormat:@"%@", obj];
        [self openSuccess];
    } fail:^(NSString * _Nullable msg, NSError * _Nullable error) {
        self.hud.mode = MBProgressHUDModeText;
        self.hud.label.text = msg;
        self.hud.detailsLabel.text = error.localizedDescription;
        [self.hud showAnimated:YES];
        [self.hud hideAnimated:YES afterDelay:10.f];
    }];
}

- (void)btnCloseClicked:(UIButton *)button {
    [UIView animateWithDuration:0.5f animations:^{
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(hongbaoViewCancel:opened:)]) {
            [self.delegate hongbaoViewCancel:self opened:self.opened];
        }
        [self removeFromSuperview];
    }];
}

- (void)showResult {
    self.backgroundView.hidden = YES;
    self.btnOpen.hidden = YES;
    self.gotBackground.hidden = NO;
    self.userIcon.hidden = NO;
    self.lbUserName.hidden = NO;
    self.lbMoney.hidden = NO;
    self.lbYuan.hidden = NO;
    self.lbResult.hidden = NO;
    self.btnKeepLooking.hidden = NO;
}

- (UIImageView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _backgroundView.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundView.image = [UIImage imageNamed:@"red_kai"];
        [self addSubview:_backgroundView];
    }
    return _backgroundView;
}

- (UIButton *)btnOpen {
    if (!_btnOpen) {
        _btnOpen = [[UIButton alloc] initWithFrame:CGRectZero];
        _btnOpen.backgroundColor = [UIColor clearColor];
        [_btnOpen addTarget:self action:@selector(btnOpenClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnOpen];
    }
    return _btnOpen;
}

- (UIButton *)btnClose {
    if (!_btnClose) {
        _btnClose = [[UIButton alloc] initWithFrame:CGRectZero];
        [_btnClose setBackgroundImage:[UIImage imageNamed:@"u173"] forState:UIControlStateNormal];
        [_btnClose addTarget:self action:@selector(btnCloseClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnClose];
    }
    return _btnClose;
}

- (UIButton *)btnKeepLooking {
    if (!_btnKeepLooking) {
        _btnKeepLooking = [[UIButton alloc] initWithFrame:CGRectZero];
        [_btnKeepLooking setTitle:@"继续寻找" forState:UIControlStateNormal];
        [_btnKeepLooking.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
        [_btnKeepLooking setBackgroundImage:[UIImage imageNamed:@"u146"] forState:UIControlStateNormal];
        [_btnKeepLooking addTarget:self action:@selector(btnCloseClicked:) forControlEvents:UIControlEventTouchUpInside];
        _btnKeepLooking.hidden = YES;
        [self addSubview:_btnKeepLooking];
    }
    return _btnKeepLooking;
}

- (UIImageView *)userIcon {
    if (!_userIcon) {
        _userIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        _userIcon.contentMode = UIViewContentModeScaleAspectFit;
        _userIcon.image = [UIImage imageNamed:@"u61"];
        _userIcon.hidden = YES;
        [self addSubview:_userIcon];
    }
    return _userIcon;
}

- (UILabel *)lbUserName {
    if (!_lbUserName) {
        _lbUserName = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbUserName.textColor = [UIColor whiteColor];
        _lbUserName.text = AZZClientInstance.userName;
        _lbUserName.textAlignment = NSTextAlignmentCenter;
        _lbUserName.hidden = YES;
        [self addSubview:_lbUserName];
    }
    return _lbUserName;
}

- (UILabel *)lbMoney {
    if (!_lbMoney) {
        _lbMoney = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbMoney.textColor = [UIColor whiteColor];
        _lbMoney.font = [UIFont systemFontOfSize:30.f];
        _lbMoney.textAlignment = NSTextAlignmentCenter;
        _lbMoney.hidden = YES;
        [self addSubview:_lbMoney];
    }
    return _lbMoney;
}

- (UILabel *)lbYuan {
    if (!_lbYuan) {
        _lbYuan = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbYuan.textColor = [UIColor whiteColor];
        _lbYuan.font = [UIFont systemFontOfSize:15.f];
        _lbYuan.textAlignment = NSTextAlignmentCenter;
        _lbYuan.text = @"元";
        _lbYuan.hidden = YES;
        [self addSubview:_lbYuan];
    }
    return _lbYuan;
}

- (UILabel *)lbResult {
    if (!_lbResult) {
        _lbResult = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbResult.textColor = [UIColor lightTextColor];
        _lbResult.font = [UIFont systemFontOfSize:15.f];
        _lbResult.textAlignment = NSTextAlignmentCenter;
        _lbResult.text = @"领取成功";
        _lbResult.hidden = YES;
        [self addSubview:_lbResult];
    }
    return _lbResult;
}

- (UIImageView *)gotBackground {
    if (!_gotBackground) {
        _gotBackground = [[UIImageView alloc] initWithFrame:CGRectZero];
        _gotBackground.contentMode = UIViewContentModeScaleToFill;
        _gotBackground.image = [UIImage imageNamed:@"u134"];
        _gotBackground.hidden = YES;
        [self addSubview:_gotBackground];
    }
    return _gotBackground;
}

- (MBProgressHUD *)hud {
    if (!_hud) {
        _hud = [[MBProgressHUD alloc] initWithView:self];
        _hud.label.numberOfLines = 0;
        _hud.detailsLabel.numberOfLines = 0;
        [self addSubview:_hud];
    }
    return _hud;
}

@end
