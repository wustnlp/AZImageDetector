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

#import "AZZClient.h"
#import "AZZImageDetector.h"

#import <Masonry/Masonry.h>
#import <SDWebImage/SDWebImageDownloader.h>

@interface AZZScanHongBaoViewController ()

@property (nonatomic, strong) UIImageView *imageView;

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
    [self showHudWithTitle:nil detail:nil];
    
    __weak typeof(self) wself = self;
    self.detector.successBlock = ^(int index) {
        NSLog(@"detect:%@", @(index));
        if (!wself.hongbaoView) {
            [wself.detector stopProcess];
            wself.hongbaoView = [AZZHongBaoView showInView:wself.view withModel:wself.model];
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
        _imageView.contentMode = UIViewContentModeCenter;
        [self.view addSubview:_imageView];
    }
    return _imageView;
}

- (void)setModel:(AZZHongBaoModel *)model {
    _model = model;
    if (model) {
        NSString *urlString = [[[AZZServerAddress stringByAppendingPathComponent:@"upload"] stringByAppendingPathComponent:model.idString] stringByAppendingPathExtension:@"png"];
        self.downloadOperation = [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:urlString] options:SDWebImageDownloaderHighPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            if (finished && image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.view class];
                    self.imgPattern = image;
                    [self.detector setPatterns:@[image]];
                    [self.detector startProcess];
                    [self hideHudAfterDelay:0];
                });
            }
        }];
    }
}

@end
