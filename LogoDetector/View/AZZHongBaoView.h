//
//  AZZHongBaoView.h
//  LogoDetector
//
//  Created by 朱安智 on 2017/1/19.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AZZHongBaoView;

@protocol AZZHongBaoViewDelegate <NSObject>

- (void)hongbaoViewCancel:(AZZHongBaoView *)hongbaoView opened:(BOOL)opened;

@end

@class AZZHongBaoModel;

@interface AZZHongBaoView : UIView

+ (instancetype)showInView:(UIView *)view withModel:(AZZHongBaoModel *)model;
- (void)showInView:(UIView *)view;

@property (nonatomic, weak) id<AZZHongBaoViewDelegate> delegate;

@end
