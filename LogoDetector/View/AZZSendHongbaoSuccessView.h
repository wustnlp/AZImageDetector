//
//  AZZSendHongbaoSuccessView.h
//  LogoDetector
//
//  Created by 朱安智 on 2017/3/31.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AZZSendHongbaoSuccessView : UIView

+ (AZZSendHongbaoSuccessView *)viewWithImage:(UIImage *)image callFriendsCallback:(void (^)())callFriends doneCallback:(void (^)())done;

@end
