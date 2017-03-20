//
//  AZZGotHongBaoViewController.m
//  LogoDetector
//
//  Created by 朱安智 on 2017/3/20.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import "AZZGotHongBaoViewController.h"

#import <Masonry/Masonry.h>

@interface AZZGotHongBaoViewController ()

@property (nonatomic, strong) UIImageView *imgBackground;

@property (nonatomic, strong) UIImageView *imgHongBao;
@property (nonatomic, strong) UIView *rect;
@property (nonatomic, strong) UILabel *lbTitle;
@property (nonatomic, strong) UILabel *lbHongbao;

@property (nonatomic, strong) UIButton *btnOK;

@end

@implementation AZZGotHongBaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = YES;
    [self setupSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1.f animations:^{
            self.btnOK.alpha = 1.f;
        }];
    });
}

- (void)buttonOKClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (NSAttributedString *)hongbao {
    NSMutableAttributedString *result = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", self.hbValue, self.hbType]].mutableCopy;
    NSRange range = NSMakeRange(0, self.hbValue.length);
    [result addAttribute:NSForegroundColorAttributeName value:[UIColor yellowColor] range:range];
    return result.copy;
}

- (void)setupSubviews {
    [self.imgBackground mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.rect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(120);
        make.centerY.equalTo(self.view);
        make.left.equalTo(self.view).with.offset(100);
        make.right.equalTo(self.view).with.offset(-40);
    }];
    [self.imgHongBao mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.rect).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(70, 131));
        make.centerX.equalTo(self.rect.mas_left);
    }];
    [self.lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.rect).with.offset(10);
        make.centerY.equalTo(self.rect).with.offset(-15);
        make.height.mas_equalTo(30);
    }];
    [self.lbHongbao mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.rect).with.offset(10);
        make.top.equalTo(self.lbTitle.mas_bottom);
        make.height.mas_equalTo(30);
    }];
    [self.btnOK mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-20);
    }];
}

#pragma mark -

- (UIImageView *)imgBackground {
    if (!_imgBackground) {
        _imgBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"u0"]];
        _imgBackground.contentMode = UIViewContentModeScaleToFill;
        [self.view addSubview:_imgBackground];
    }
    return _imgBackground;
}

- (UIImageView *)imgHongBao {
    if (!_imgHongBao) {
        _imgHongBao = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"u84"]];
        _imgHongBao.contentMode = UIViewContentModeScaleAspectFit;
        _imgHongBao.transform = CGAffineTransformMakeRotation(-(21.f * M_PI / 180.f));
        [self.view addSubview:_imgHongBao];
    }
    return _imgHongBao;
}

- (UIView *)rect {
    if (!_rect) {
        _rect = [[UIView alloc] initWithFrame:CGRectZero];
        _rect.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.01];
        _rect.layer.borderWidth = 1.f;
        _rect.layer.borderColor = [UIColor colorWithRed:119.f / 255.f green:119.f / 255.f blue:119.f / 255.f alpha:1.f].CGColor;
        [self.view addSubview:_rect];
    }
    return _rect;
}

- (UILabel *)lbTitle {
    if (!_lbTitle) {
        _lbTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbTitle.textAlignment = NSTextAlignmentCenter;
        _lbTitle.textColor = [UIColor whiteColor];
        _lbTitle.font = [UIFont systemFontOfSize:14.f];
        _lbTitle.text = @"恭喜你！这个红包里有";
        [self.rect addSubview:_lbTitle];
    }
    return _lbTitle;
}

- (UILabel *)lbHongbao {
    if (!_lbHongbao) {
        _lbHongbao = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbHongbao.textAlignment = NSTextAlignmentCenter;
        _lbHongbao.textColor = [UIColor whiteColor];
        _lbHongbao.font = [UIFont systemFontOfSize:14.f];
        _lbHongbao.attributedText = self.hongbao;
        [self.rect addSubview:_lbHongbao];
    }
    return _lbHongbao;
}

- (UIButton *)btnOK {
    if (!_btnOK) {
        _btnOK = [[UIButton alloc] initWithFrame:CGRectZero];
        [_btnOK setTitle:@"知道啦" forState:UIControlStateNormal];
        [_btnOK addTarget:self action:@selector(buttonOKClicked:) forControlEvents:UIControlEventTouchUpInside];
        _btnOK.alpha = 0;
        [self.view addSubview:_btnOK];
    }
    return _btnOK;
}

@end
