//
//  AZZScanHongBaoViewController.m
//  LogoDetector
//
//  Created by 朱安智 on 2017/1/13.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import "AZZScanHongBaoViewController.h"
#import "AZZHongBaoModel.h"
#import "AZZHongBaoView.h"

#import "UMSSpinnerView.h"

#import "AZZClient.h"
#import "AZZImageDetector.h"

#import <Masonry/Masonry.h>
#import <SDWebImage/SDWebImageManager.h>

@interface AZZScanHongBaoViewController () <AZZHongBaoViewDelegate>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *btnView;
@property (nonatomic, strong) UIImageView *imageSee;
@property (nonatomic, strong) UILabel *lbSee;
@property (nonatomic, strong) UILabel *lbMessage;

@property (nonatomic, strong) UMSSpinnerView *spinnerView;

@property (nonatomic, strong) AZZImageDetector *detector;
@property (nonatomic, strong) UIImage *imgPattern;

@property (nonatomic, strong) AZZHongBaoView *hongbaoView;

@property (nonatomic, strong) id<SDWebImageOperation> downloadOperation;

@end

@implementation AZZScanHongBaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupConstraints];
    [self showHudWithTitle:@"请稍等" detail:@"正在下载图片"];
    
    __weak typeof(self) wself = self;
    self.detector.successBlock = ^(int index) {
        NSLog(@"detect:%@", @(index));
        [wself.detector stopProcess];
        [wself showItems:NO];
        if (!wself.hongbaoView) {
            wself.hongbaoView = [AZZHongBaoView showInView:wself.view withModel:wself.model];
            wself.hongbaoView.delegate = wself;
        } else {
            [wself.hongbaoView showInView:wself.view];
        }
    };
    self.detector.failBlock = ^(int index) {
        NSLog(@"lose:%@", @(index));
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (self.downloadOperation) {
        [self.downloadOperation cancel];
    }
}

- (void)setupConstraints {
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(64.f);
        make.left.and.right.and.bottom.equalTo(self.view);
    }];
    [self.spinnerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.spinnerView.mas_height);
        make.left.and.right.equalTo(self.view);
        make.centerY.equalTo(self.view);
    }];
    [self.btnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).with.offset(-40);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [self.lbSee mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.btnView);
        make.top.equalTo(self.btnView.mas_bottom);
    }];
    [self.imageSee mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.btnView);
        make.bottom.equalTo(self.btnView.mas_top);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    [self.lbMessage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(80);
        make.width.mas_equalTo(200);
    }];
}

- (void)hongbaoViewCancel:(AZZHongBaoView *)hongbaoView opened:(BOOL)opened {
    if (hongbaoView == self.hongbaoView) {
        if (opened) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self.detector startProcess];
            [self showItems:YES];
        }
    }
}

- (void)btnViewTouchDown:(UIButton *)button {
    self.imageSee.hidden = NO;
}

- (void)btnViewTouchUp:(UIButton *)button {
    self.imageSee.hidden = YES;
}

- (void)showItems:(BOOL)show {
    show ? [self.spinnerView startAnimating] : [self.spinnerView stopAnimating];
    self.btnView.hidden = !show;
    self.lbSee.hidden = !show;
    self.lbMessage.hidden = !show;
}

#pragma mark - Property

- (AZZImageDetector *)detector {
    if (!_detector) {
        _detector = [AZZImageDetector detectorWithImageView:self.imageView];
    }
    return _detector;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleToFill;
        [self.view addSubview:_imageView];
    }
    return _imageView;
}

- (UIImageView *)imageSee {
    if (!_imageSee) {
        _imageSee = [UIImageView new];
        _imageSee.contentMode = UIViewContentModeScaleToFill;
        _imageSee.transform = CGAffineTransformMakeRotation(M_PI / 2.f);
        _imageSee.hidden = YES;
        [self.view addSubview:_imageSee];
    }
    return _imageSee;
}

- (UILabel *)lbSee {
    if (!_lbSee) {
        _lbSee = [UILabel new];
        _lbSee.textAlignment = NSTextAlignmentCenter;
        _lbSee.textColor = [UIColor whiteColor];
        _lbSee.text = @"按住看线索";
        _lbSee.font = [UIFont systemFontOfSize:11.f];
        _lbSee.hidden = YES;
        [self.view addSubview:_lbSee];
    }
    return _lbSee;
}

- (UILabel *)lbMessage {
    if (!_lbMessage) {
        _lbMessage = [UILabel new];
        _lbMessage.textAlignment = NSTextAlignmentCenter;
        _lbMessage.textColor = [UIColor blackColor];
        _lbMessage.numberOfLines = 0;
        _lbMessage.text = self.model.message;
        _lbMessage.hidden = YES;
        [self.view addSubview:_lbMessage];
    }
    return _lbMessage;
}

- (UIButton *)btnView {
    if (!_btnView) {
        _btnView = [[UIButton alloc] initWithFrame:CGRectZero];
        [_btnView setBackgroundImage:[UIImage imageNamed:@"u128"] forState:UIControlStateNormal];
        _btnView.contentMode = UIViewContentModeScaleAspectFit;
        [_btnView addTarget:self action:@selector(btnViewTouchDown:) forControlEvents:UIControlEventTouchDown];
        [_btnView addTarget:self action:@selector(btnViewTouchUp:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        _btnView.hidden = YES;
        [self.view addSubview:_btnView];
    }
    return _btnView;
}

- (UMSSpinnerView *)spinnerView {
    if (!_spinnerView) {
        _spinnerView = [[UMSSpinnerView alloc] initWithFrame:CGRectZero];
        _spinnerView.lineWidth = 2.f;
        _spinnerView.tintColor = [UIColor redColor];
        _spinnerView.translatesAutoresizingMaskIntoConstraints = NO;
        _spinnerView.userInteractionEnabled = NO;
        _spinnerView.hidesWhenStopped = YES;
        [self.view addSubview:_spinnerView];
    }
    return _spinnerView;
}

- (void)setModel:(AZZHongBaoModel *)model {
    _model = model;
    if (model) {
        NSString *urlString = [[[AZZServerAddress stringByAppendingPathComponent:@"luan/upload"] stringByAppendingPathComponent:model.idString] stringByAppendingPathExtension:@"png"];
        self.downloadOperation = [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:urlString] options:SDWebImageRetryFailed | SDWebImageHighPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (finished && image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.view class];
                    self.imgPattern = image;
                    self.imageSee.image = image;
                    [self showItems:YES];
                    [self.detector setPatterns:@[image]];
                    [self.detector startProcess];
                    [self hideHudAfterDelay:0];
                });
            } else {
                [self showHudWithTitle:@"图片下载失败" detail:[NSString stringWithFormat:@"domain:%@ code:%@ description:%@", error.domain, @(error.code), error.localizedDescription]];
            }
        }];
    }
}

@end
