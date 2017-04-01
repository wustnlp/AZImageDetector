//
//  AZZImageDetector.h
//  LogoDetector
//
//  Created by 朱安智 on 2017/1/6.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AZZImageDetector_Success)(int index, UIImage *image);
typedef void(^AZZImageDetector_Fail)(int index);

@interface AZZImageDetector : NSObject

@property (nonatomic, copy) AZZImageDetector_Success successBlock;
@property (nonatomic, copy) AZZImageDetector_Fail failBlock;

+ (instancetype)detectorWithImageView:(UIImageView *)imageView;
- (void)setPatterns:(NSArray<UIImage *> *)patterns;
- (void)startProcess;
- (void)stopProcess;

@end
