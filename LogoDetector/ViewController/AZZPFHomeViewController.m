//
//  AZZPFHomeViewController.m
//  LogoDetector
//
//  Created by 朱安智 on 2017/3/17.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import "AZZPFHomeViewController.h"
#import "AZZCenterTitleButton.h"

#import <Masonry/Masonry.h>

@interface AZZPFHomeViewController ()

@property (nonatomic, strong) UIImageView *imgBackground;
@property (nonatomic, strong) UIButton *btnUser;
@property (nonatomic, strong) AZZCenterTitleButton *btnSend;
@property (nonatomic, strong) AZZCenterTitleButton *btnOne;
@property (nonatomic, strong) AZZCenterTitleButton *btnTwenty;
@property (nonatomic, strong) AZZCenterTitleButton *btnEight;
@property (nonatomic, strong) UILabel *lbLineOne;
@property (nonatomic, strong) UILabel *lbLineTwo;

@property (nonatomic, strong) UIView *vOne;
@property (nonatomic, strong) UIView *vTwo;

@end

@implementation AZZPFHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - 

- (void)setupSubviews {
    [self.imgBackground mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.btnUser mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(30);
        make.top.equalTo(self.view).with.offset(32);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    [self.btnSend mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).with.offset(-15);
        make.centerY.equalTo(self.btnUser);
        make.size.mas_equalTo(CGSizeMake(88, 88));
    }];
    [self.btnOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(16);
        make.size.mas_equalTo(CGSizeMake(100, 100));
        make.bottom.equalTo(self.view).with.offset(-120);
    }];
    [self.vOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.btnOne.mas_right);
        make.height.mas_equalTo(1);
        make.centerY.equalTo(self.btnOne);
    }];
    [self.btnTwenty mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.vOne.mas_right);
        make.size.and.centerY.equalTo(self.btnOne);
    }];
    [self.vTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.btnTwenty.mas_right);
        make.size.and.centerY.equalTo(self.vOne);
    }];
    [self.btnEight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.vTwo.mas_right);
        make.size.and.centerY.equalTo(self.btnTwenty);
        make.right.equalTo(self.view).with.offset(-8);
    }];
    [self.lbLineOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).with.offset(8);
        make.right.equalTo(self.view).with.offset(-8);
    }];
    [self.lbLineTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lbLineOne.mas_bottom);
        make.left.and.right.equalTo(self.lbLineOne);
        make.bottom.equalTo(self.view).with.offset(-60);
    }];
}

- (UIImageView *)imgBackground {
    if (!_imgBackground) {
        _imgBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"u0"]];
        _imgBackground.contentMode = UIViewContentModeScaleToFill;
        [self.view addSubview:_imgBackground];
    }
    return _imgBackground;
}

- (UIButton *)btnUser {
    if (!_btnUser) {
        _btnUser = [[UIButton alloc] initWithFrame:CGRectZero];
        [_btnUser setImage:[UIImage imageNamed:@"u36"] forState:UIControlStateNormal];
        [self.view addSubview:_btnUser];
    }
    return _btnUser;
}

- (AZZCenterTitleButton *)btnSend {
    if (!_btnSend) {
        _btnSend = [[AZZCenterTitleButton alloc] initWithFrame:CGRectZero];
        [_btnSend.imgBackground setImage:[UIImage imageNamed:@"送红包_u34"]];
        _btnSend.lbTitle.text = @"送红包";
        _btnSend.lbTitle.textColor = [UIColor yellowColor];
        _btnSend.lbTitle.font = [UIFont systemFontOfSize:24.f];
        [self.view addSubview:_btnSend];
    }
    return _btnSend;
}

- (AZZCenterTitleButton *)btnOne {
    if (!_btnOne) {
        _btnOne = [[AZZCenterTitleButton alloc] initWithFrame:CGRectZero];
        [_btnOne.imgBackground setImage:[UIImage imageNamed:@"u4"]];
        _btnOne.lbTitle.text = @"壹";
        _btnOne.lbTitle.textColor = [UIColor yellowColor];
        _btnOne.lbTitle.font = [UIFont systemFontOfSize:46.f];
        [self.view addSubview:_btnOne];
    }
    return _btnOne;
}

- (AZZCenterTitleButton *)btnTwenty {
    if (!_btnTwenty) {
        _btnTwenty = [[AZZCenterTitleButton alloc] initWithFrame:CGRectZero];
        [_btnTwenty.imgBackground setImage:[UIImage imageNamed:@"u4"]];
        _btnTwenty.lbTitle.text = @"贰拾";
        _btnTwenty.lbTitle.textColor = [UIColor yellowColor];
        _btnTwenty.lbTitle.font = [UIFont systemFontOfSize:46.f];
        [self.view addSubview:_btnTwenty];
    }
    return _btnTwenty;
}

- (AZZCenterTitleButton *)btnEight {
    if (!_btnEight) {
        _btnEight = [[AZZCenterTitleButton alloc] initWithFrame:CGRectZero];
        [_btnEight.imgBackground setImage:[UIImage imageNamed:@"u4"]];
        _btnEight.lbTitle.text = @"捌";
        _btnEight.lbTitle.textColor = [UIColor yellowColor];
        _btnEight.lbTitle.font = [UIFont systemFontOfSize:46.f];
        [self.view addSubview:_btnEight];
    }
    return _btnEight;
}

- (UIView *)vOne {
    if (!_vOne) {
        _vOne = [[UIView alloc] initWithFrame:CGRectZero];
        _vOne.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_vOne];
    }
    return _vOne;
}

- (UIView *)vTwo {
    if (!_vTwo) {
        _vTwo = [[UIView alloc] initWithFrame:CGRectZero];
        _vTwo.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_vTwo];
    }
    return _vTwo;
}

- (UILabel *)lbLineOne {
    if (!_lbLineOne) {
        _lbLineOne = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbLineOne.numberOfLines = 0;
        _lbLineOne.font = [UIFont systemFontOfSize:14.f];
        _lbLineOne.text = @"您可分别使用1个、8个、20个的方式打开红包哦！";
        _lbLineOne.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_lbLineOne];
    }
    return _lbLineOne;
}

- (UILabel *)lbLineTwo {
    if (!_lbLineTwo) {
        _lbLineTwo = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbLineTwo.numberOfLines = 0;
        _lbLineTwo.font = [UIFont systemFontOfSize:14.f];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"您目前有X个红包！"];
        NSRange range = [attrString.string rangeOfString:@"X"];
        NSString *number = @"X"; //TODO
        range.length = number.length;
        [attrString replaceCharactersInRange:range withString:number];
        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor yellowColor] range:range];
        _lbLineTwo.attributedText = attrString.copy;
        _lbLineTwo.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_lbLineTwo];
    }
    return _lbLineTwo;
}

@end
