//
//  AZZSendHongbaoSuccessView.m
//  LogoDetector
//
//  Created by 朱安智 on 2017/3/31.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import "AZZSendHongbaoSuccessView.h"
#import "AZZLocationView.h"

#import <Masonry/Masonry.h>

@interface AZZSendHongbaoSuccessView ()

@property (nonatomic, strong) UIImageView *imgBackground;
@property (nonatomic, strong) UIImageView *imgPic;
@property (nonatomic, strong) AZZLocationView *locationView;
@property (nonatomic, strong) UIButton *btnCallFriends;
@property (nonatomic, strong) UIButton *btnDone;

@property (nonatomic, strong) UIImage *pic;

@property (nonatomic, copy) void (^callFriends)();
@property (nonatomic, copy) void (^done)();

@end

@implementation AZZSendHongbaoSuccessView

+ (AZZSendHongbaoSuccessView *)viewWithImage:(UIImage *)image callFriendsCallback:(void (^)())callFriends doneCallback:(void (^)())done {
    AZZSendHongbaoSuccessView *instance = [AZZSendHongbaoSuccessView new];
    instance.pic = image;
    instance.callFriends = callFriends;
    instance.done = done;
    return instance;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    [self setupConstraints];
}

- (void)btnCallFriendsClicked:(UIButton *)button {
    if (self.callFriends) {
        self.callFriends();
    }
}

- (void)btnDoneClicked:(UIButton *)button {
    if (self.done) {
        self.done();
    }
}

- (void)setupConstraints {
    [self.imgBackground mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.imgPic mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).with.offset(20);
        make.width.equalTo(self.imgPic.mas_height);
        make.left.equalTo(self).with.offset(60);
    }];
    [self.locationView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgPic.mas_bottom).with.offset(20);
        make.centerX.equalTo(self.imgPic);
        make.width.equalTo(self.imgPic).with.offset(-20);
    }];
    [self.btnCallFriends mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.locationView);
        make.top.equalTo(self.locationView.mas_bottom).with.offset(20);
        make.size.equalTo(self.locationView).with.sizeOffset(CGSizeMake(-20, 0));
    }];
    [self.btnDone mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.btnCallFriends);
        make.size.equalTo(self.btnCallFriends);
        make.top.equalTo(self.btnCallFriends.mas_bottom).with.offset(10);
    }];
}

- (UIImageView *)imgBackground {
    if (!_imgBackground) {
        _imgBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"u134"]];
        _imgBackground.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_imgBackground];
    }
    return _imgBackground;
}

- (UIImageView *)imgPic {
    if (!_imgPic) {
        _imgPic = [[UIImageView alloc] initWithImage:self.pic];
        _imgPic.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imgPic];
    }
    return _imgPic;
}

- (AZZLocationView *)locationView {
    if (!_locationView) {
        _locationView = [AZZLocationView new];
        [self addSubview:_locationView];
    }
    return _locationView;
}

- (UIButton *)btnCallFriends {
    if (!_btnCallFriends) {
        _btnCallFriends = [[UIButton alloc] initWithFrame:CGRectZero];
        [_btnCallFriends setTitle:@"呼唤小伙伴" forState:UIControlStateNormal];
        [_btnCallFriends setBackgroundImage:[UIImage imageNamed:@"u146"] forState:UIControlStateNormal];
        _btnCallFriends.contentMode = UIViewContentModeScaleToFill;
        [_btnCallFriends addTarget:self action:@selector(btnCallFriendsClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnCallFriends];
    }
    return _btnCallFriends;
}

- (UIButton *)btnDone {
    if (!_btnDone) {
        _btnDone = [[UIButton alloc] initWithFrame:CGRectZero];
        [_btnDone setTitle:@"完成" forState:UIControlStateNormal];
        [_btnDone setBackgroundImage:[UIImage imageNamed:@"u146"] forState:UIControlStateNormal];
        _btnDone.contentMode = UIViewContentModeScaleToFill;
        [_btnDone addTarget:self action:@selector(btnDoneClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnDone];
    }
    return _btnDone;
}

@end
