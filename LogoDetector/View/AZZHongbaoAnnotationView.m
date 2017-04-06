//
//  AZZHongbaoAnnotationView.m
//  LogoDetector
//
//  Created by 朱安智 on 2017/4/1.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import "AZZHongbaoAnnotationView.h"
#import "AZZMapAnnotation.h"
#import "AZZHongBaoModel.h"

#import <Masonry/Masonry.h>

@interface AZZHongbaoAnnotationView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tbList;
@property (nonatomic, strong) UIButton *btnBackground;
@property (nonatomic, strong) UIButton *btnCancel;

@end

@implementation AZZHongbaoAnnotationView

+ (AZZHongbaoAnnotationView *)annotationViewWithMapView:(MKMapView *)mapView annotation:(AZZMapAnnotation *)annotation {
    AZZHongbaoAnnotationView *instance = (AZZHongbaoAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:NSStringFromClass(self.class)];
    if (!instance) {
        instance = [[AZZHongbaoAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:NSStringFromClass(self.class)];
    } else {
        instance.annotation = annotation;
    }
    [instance setupConstraints];
    instance.image = [UIImage imageNamed:@"hongbao_annotation"];
    instance.frame = CGRectMake(0, 0, 40, 40);
    
    return instance;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self showTableView:NO];
    self.callback = nil;
}

- (void)setupConstraints {
    [self.tbList mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.equalTo(self);
    }];
    [self.btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.equalTo(self).with.offset(20.f);
        make.centerX.equalTo(self);
        make.top.equalTo(self.tbList.mas_bottom);
    }];
    [self.btnBackground mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    AZZMapAnnotation *annotation = self.annotation;
    return annotation.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    AZZMapAnnotation *annotation = self.annotation;
    cell.textLabel.text = annotation.models[indexPath.row].message;
    cell.imageView.image = [UIImage imageNamed:@"hongbao_annotation"];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.callback) {
        AZZMapAnnotation *annotation = self.annotation;
        self.callback(annotation.models[indexPath.row]);
        [self showTableView:NO];
    }
}

- (void)btnBackgroundClicked:(UIButton *)button {
    AZZMapAnnotation *annotation = self.annotation;
    if (annotation.models.count > 0) {
        [self showTableView:YES];
    } else {
        if (self.callback) {
            self.callback(annotation.model);
        }
    }
}

- (void)btnCancelClicked:(UIButton *)button {
    [self showTableView:NO];
}

- (void)showTableView:(BOOL)show {
    self.tbList.hidden = !show;
    self.btnBackground.hidden = show;
    CGRect frame = self.frame;
    frame.size = show ? CGSizeMake(200, 200) : CGSizeMake(40, 40);
    self.frame = frame;
    self.image = show ? nil : [UIImage imageNamed:@"hongbao_annotation"];
    self.btnCancel.hidden = !show;
    [self setNeedsLayout];
}

- (UITableView *)tbList {
    if (!_tbList) {
        _tbList = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tbList.delegate = self;
        _tbList.dataSource = self;
        _tbList.backgroundColor = [UIColor clearColor];
        _tbList.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tbList.hidden = YES;
        [self addSubview:_tbList];
    }
    return _tbList;
}

- (UIButton *)btnBackground {
    if (!_btnBackground) {
        _btnBackground = [[UIButton alloc] initWithFrame:CGRectZero];
        _btnBackground.backgroundColor = [UIColor clearColor];
        [_btnBackground addTarget:self action:@selector(btnBackgroundClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnBackground];
    }
    return _btnBackground;
}

- (UIButton *)btnCancel {
    if (!_btnCancel) {
        _btnCancel = [[UIButton alloc] initWithFrame:CGRectZero];
        _btnCancel.backgroundColor =  [UIColor colorWithRed:45/255.0 green:187/255.0 blue:253/255.0 alpha:1/1.0];;
        [_btnCancel setTitle:@"取消" forState:UIControlStateNormal];
        [_btnCancel addTarget:self action:@selector(btnCancelClicked:) forControlEvents:UIControlEventTouchUpInside];
        _btnCancel.hidden = YES;
        [self addSubview:_btnCancel];
    }
    return _btnCancel;
}

@end
