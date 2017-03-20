//
//  AZZUserActionsTableViewCell.h
//  LogoDetector
//
//  Created by 朱安智 on 2017/3/20.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AZZUserActionsTableViewCell : UITableViewCell

+ (AZZUserActionsTableViewCell *)cellWithTableView:(UITableView *)tableView image:(UIImage *)image title:(NSString *)title detail:(NSString *)detail;

@end
