//
//  ImageUtils.h
//  OpenCVTest
//
//  Created by DNVA on 24/03/16.
//  Copyright © 2016 DNVA. All rights reserved.
//

#import <UIKit/UIKit.h>

#include <opencv2/opencv.hpp>

@interface AZZImageUtils : NSObject

+ (cv::Mat)cvMatFromUIImage:(UIImage *)image;
+ (UIImage *) UIImageFromCVMat: (cv::Mat)cvMat;
+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
+ (UIImage *)croppedImage:(UIImage *)image InRect:(CGRect)rect;

@end
