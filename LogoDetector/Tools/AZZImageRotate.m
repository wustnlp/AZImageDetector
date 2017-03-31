//
//  AZZImageRotate.m
//  LogoDetector
//
//  Created by 朱安智 on 2017/3/31.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import "AZZImageRotate.h"

@implementation AZZImageRotate

+ (UIImage *)imageRotatedByDegrees:(UIImage*)oldImage deg:(CGFloat)degrees{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,oldImage.size.width, oldImage.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(degrees * M_PI / 180);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, (degrees * M_PI / 180));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-oldImage.size.width / 2, -oldImage.size.height / 2, oldImage.size.width, oldImage.size.height), [oldImage CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//static inline double radians (double degrees) {return degrees * M_PI/180;}
+ (UIImage *)rotateImage:(UIImage *)src orientation:(UIImageOrientation)orientation {
    
//    return [[UIImage alloc] initWithCGImage: src.CGImage
//                               scale: 1.0
//                         orientation: orientation];
//    UIGraphicsBeginImageContext(src.size);
    
//    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orientation == UIImageOrientationRight) {
        return [self imageRotatedByDegrees:src deg:90];
//        CGContextRotateCTM (context, radians(90));
    } else if (orientation == UIImageOrientationLeft) {
//        CGContextRotateCTM (context, radians(-90));
        return [self imageRotatedByDegrees:src deg:-90];
    } else if (orientation == UIImageOrientationDown) {
        // NOTHING
    } else if (orientation == UIImageOrientationUp) {
//        CGContextRotateCTM (context, radians(90));
    }
    
//    [src drawAtPoint:CGPointMake(0, 0)];
    
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    return src;
}

@end
