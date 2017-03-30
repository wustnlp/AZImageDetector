//
//  AZZHongBaoViewProtocol.h
//  LogoDetector
//
//  Created by 朱安智 on 2017/3/30.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#ifndef AZZHongBaoViewProtocol_h
#define AZZHongBaoViewProtocol_h

#import <UIKit/UIKit.h>

@protocol AZZHongBaoViewDelegate <NSObject>

- (void)hongbaoViewCancel:(UIView *)hongbaoView opened:(BOOL)opened;

@end

#endif /* AZZHongBaoViewProtocol_h */
