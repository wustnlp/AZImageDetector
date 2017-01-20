//
//  AZZHongBaoView.m
//  LogoDetector
//
//  Created by 朱安智 on 2017/1/19.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import "AZZHongBaoView.h"
#import "AZZHongBaoModel.h"
#import "AZZHongBaoGotUserModel.h"

#import "AZZClient.h"

#import <Masonry/Masonry.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface AZZHongBaoView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIButton *btnOpen;
@property (nonatomic, strong) UIButton *btnClose;
@property (nonatomic, strong) UITableView *tbResults;
@property (nonatomic, strong) UILabel *lbHongBao;

@property (nonatomic, copy) AZZHongBaoModel *hongbaoModel;
@property (nonatomic, copy) NSArray<AZZHongBaoGotUserModel *> *gotUsers;

@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation AZZHongBaoView

#pragma mark - Public

+ (instancetype)showInView:(UIView *)view withModel:(AZZHongBaoModel *)model {
    AZZHongBaoView *instance = [[AZZHongBaoView alloc] initWithFrame:CGRectZero];
    instance.alpha = 0.f;
    [view addSubview:instance];
    [instance mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
    instance.hongbaoModel = model;
    [UIView animateWithDuration:2.f animations:^{
        instance.frame = view.bounds;
        instance.alpha = 1;
    }];
    return instance;
}

- (void)showInView:(UIView *)view {
    self.alpha = 0.f;
    self.frame = CGRectZero;
    [view addSubview:self];
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
    [UIView animateWithDuration:2.f
                     animations:^{
                         self.frame = view.bounds;
                         self.alpha = 1.f;
                     }];
}

#pragma mark - 

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    [self setupConstaints];
}

- (void)setupConstaints {
    [self.btnOpen mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    [self.lbHongBao mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.equalTo(self).with.offset(5);
        make.right.equalTo(self).with.offset(-5);
        make.height.mas_equalTo(40);
    }];
    [self.tbResults mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lbHongBao.mas_bottom).with.offset(5);
        make.left.and.right.equalTo(self.lbHongBao);
        make.bottom.equalTo(self).with.offset(-5);
    }];
    [self.btnClose mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.and.right.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(10, 10));
    }];
    [self bringSubviewToFront:self.btnClose];
}

- (void)btnOpenClicked:(UIButton *)button {
    self.hud.mode = MBProgressHUDModeIndeterminate;
    [self.hud showAnimated:YES];
    [AZZClientInstance requestGetHongWithUUID:self.hongbaoModel.idString BaoSuccess:^(NSString * _Nullable msg, id  _Nullable obj) {
        self.lbHongBao.text = [NSString stringWithFormat:@"msg:%@ cost:%@", msg, obj];
        [self openSuccess];
    } fail:^(NSString * _Nullable msg, NSError * _Nullable error) {
        self.hud.mode = MBProgressHUDModeText;
        self.hud.label.text = msg;
        self.hud.detailsLabel.text = error.localizedDescription;
        [self.hud showAnimated:YES];
        [self.hud hideAnimated:YES afterDelay:3.f];
    }];
}

- (void)btnCloseClicked:(UIButton *)button {
    [UIView animateWithDuration:2.f animations:^{
        self.frame = CGRectZero;
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)openSuccess {
    self.btnOpen.hidden = YES;
    self.lbHongBao.hidden = NO;
    self.tbResults.hidden = NO;
    [AZZClientInstance requestGetGotUsersWithHongbaoID:self.hongbaoModel.idString success:^(NSArray<AZZHongBaoGotUserModel *> * _Nullable users) {
        self.gotUsers = users;
        [self.tbResults reloadData];
    } fail:^(NSString * _Nullable msg, NSError * _Nullable error) {
        NSLog(@"get got users with msg:%@ error:%@", msg, error);
    }];
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.gotUsers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"gotusers"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"gotusers"];
    }
    AZZHongBaoGotUserModel *model = self.gotUsers[indexPath.row];
    cell.textLabel.text = model.username;
    cell.detailTextLabel.text = [@(model.gotcost) stringValue];
    return cell;
}

#pragma mark - Property

- (UIButton *)btnOpen {
    if (!_btnOpen) {
        _btnOpen = [[UIButton alloc] initWithFrame:CGRectZero];
        [_btnOpen setTitle:@"开" forState:UIControlStateNormal];
        _btnOpen.layer.backgroundColor = [UIColor redColor].CGColor;
        _btnOpen.layer.cornerRadius = 50.f;
        [_btnOpen addTarget:self action:@selector(btnOpenClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnOpen];
    }
    return _btnOpen;
}

- (UILabel *)lbHongBao {
    if (!_lbHongBao) {
        _lbHongBao = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbHongBao.hidden = YES;
        [self addSubview:_lbHongBao];
    }
    return _lbHongBao;
}

- (UITableView *)tbResults {
    if (!_tbResults) {
        _tbResults = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tbResults.delegate = self;
        _tbResults.dataSource = self;
        _tbResults.allowsSelection = NO;
        _tbResults.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tbResults.hidden = YES;
        [self addSubview:_tbResults];
    }
    return _tbResults;
}

- (UIButton *)btnClose {
    if (!_btnClose) {
        _btnClose = [[UIButton alloc] initWithFrame:CGRectZero];
        [_btnClose setTitle:@"X" forState:UIControlStateNormal];
        _btnClose.backgroundColor = [UIColor lightGrayColor];
        [_btnClose addTarget:self action:@selector(btnCloseClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnClose];
    }
    return _btnClose;
}

- (MBProgressHUD *)hud {
    if (!_hud) {
        _hud = [[MBProgressHUD alloc] initWithView:self];
        [self addSubview:_hud];
    }
    return _hud;
}

@end