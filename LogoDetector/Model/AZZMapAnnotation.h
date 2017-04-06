//
//  AZZMapAnnotation.h
//  LogoDetector
//
//  Created by 朱安智 on 2017/1/13.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class AZZHongBaoModel;

@interface AZZMapAnnotation : NSObject <MKAnnotation>

@property (nonatomic, strong, readonly) AZZHongBaoModel *model;
@property (nonatomic, copy, readonly) NSArray<AZZHongBaoModel *> *models;

+ (AZZMapAnnotation *)annotationWithModel:(AZZHongBaoModel *)model;
+ (AZZMapAnnotation *)annotationWithTitle:(NSString *)title coor:(CLLocationCoordinate2D)coor;
+ (AZZMapAnnotation *)annotationWithLocation:(CLLocation *)location models:(NSArray<AZZHongBaoModel *> *)models;

@end
