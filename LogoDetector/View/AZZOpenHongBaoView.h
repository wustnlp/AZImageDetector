//
//  AZZOpenHongBaoView.h
//  LogoDetector
//
//  Created by 朱安智 on 2017/3/30.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AZZHongBaoViewProtocol.h"

@class AZZHongBaoModel;

@interface AZZOpenHongBaoView : UIView

+ (instancetype)showInView:(UIView *)view withModel:(AZZHongBaoModel *)model;
- (void)showInView:(UIView *)view;

@property (nonatomic, weak) id<AZZHongBaoViewDelegate> delegate;

@end
