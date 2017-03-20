//
//  AZZUserCenterViewController.m
//  LogoDetector
//
//  Created by 朱安智 on 2017/3/20.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import "AZZUserCenterViewController.h"
#import "AZZClient.h"
#import "AZZUserActionsTableViewCell.h"

#import <Masonry/Masonry.h>

@interface AZZUserCenterViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *header;
@property (nonatomic, strong) UIImageView *imgUser;
@property (nonatomic, strong) UILabel *lbUserName;

@property (nonatomic, strong) UITableView *tbActions;

@property (nonatomic, strong) UIButton *btnBack;

@property (nonatomic, strong) NSArray<NSString *> *aryTitles;
@property (nonatomic, strong) NSArray<NSString *> *aryDetails;
@property (nonatomic, strong) NSArray<UIImage *> *aryImages;

@end

@implementation AZZUserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBarHidden = YES;
    
    self.view.backgroundColor = [UIColor colorWithRed:242.f / 255.f green:242.f / 255.f blue:242.f / 255.f alpha:1];
    
    [self setupSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupSubviews {
    [self.header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.equalTo(self.view);
        make.height.mas_equalTo(220);
    }];
    [self.imgUser mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.header);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    [self.lbUserName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.imgUser);
        make.top.equalTo(self.imgUser.mas_bottom).with.offset(8);
    }];
    [self.btnBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.equalTo(self.header).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [self.tbActions mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.header.mas_bottom).with.offset(40);
        make.left.and.bottom.and.right.equalTo(self.view);
    }];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [AZZUserActionsTableViewCell cellWithTableView:tableView image:self.aryImages[indexPath.row] title:self.aryTitles[indexPath.row] detail:self.aryDetails[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 

- (UIView *)header {
    if (!_header) {
        _header = [[UIView alloc] initWithFrame:CGRectZero];
        _header.backgroundColor = [UIColor redColor];
        [self.view addSubview:_header];
    }
    return _header;
}

- (UIImageView *)imgUser {
    if (!_imgUser) {
        _imgUser = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imgUser.contentMode = UIViewContentModeScaleAspectFit;
        _imgUser.image = [UIImage imageNamed:@"u61"];
        [self.header addSubview:_imgUser];
    }
    return _imgUser;
}

- (UILabel *)lbUserName {
    if (!_lbUserName) {
        _lbUserName = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbUserName.textAlignment = NSTextAlignmentCenter;
        _lbUserName.text = AZZClientInstance.userName;
        _lbUserName.textColor = [UIColor yellowColor];
        [self.header addSubview:_lbUserName];
    }
    return _lbUserName;
}

- (UITableView *)tbActions {
    if (!_tbActions) {
        _tbActions = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tbActions.delegate = self;
        _tbActions.dataSource = self;
        [_tbActions registerClass:[AZZUserActionsTableViewCell class] forCellReuseIdentifier:NSStringFromClass([AZZUserActionsTableViewCell class])];
        _tbActions.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tbActions.backgroundColor = [UIColor clearColor];
        _tbActions.scrollEnabled = NO;
        [self.view addSubview:_tbActions];
    }
    return _tbActions;
}

- (UIButton *)btnBack {
    if (!_btnBack) {
        _btnBack = [[UIButton alloc] initWithFrame:CGRectZero];
        [_btnBack setBackgroundImage:[UIImage imageNamed:@"u59"] forState:UIControlStateNormal];
        [_btnBack addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.header addSubview:_btnBack];
    }
    return _btnBack;
}

- (NSArray<NSString *> *)aryTitles {
    if (!_aryTitles) {
        _aryTitles = @[@"我的红包", @"AR红包", @"地图红包"];
    }
    return _aryTitles;
}

- (NSArray<NSString *> *)aryDetails {
    if (!_aryDetails) {
        _aryDetails = @[@"*个", @"", @""];
    }
    return _aryDetails;
}

- (NSArray<UIImage *> *)aryImages {
    if (!_aryImages) {
        _aryImages = @[[UIImage imageNamed:@"u47"], [UIImage imageNamed:@"u57"], [UIImage imageNamed:@"u52"]];
    }
    return _aryImages;
}

@end
