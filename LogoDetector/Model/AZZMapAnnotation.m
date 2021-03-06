//
//  AZZMapAnnotation.m
//  LogoDetector
//
//  Created by 朱安智 on 2017/1/13.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import "AZZMapAnnotation.h"

#import "AZZHongBaoModel.h"

@interface AZZMapAnnotation ()

@property (nonatomic, assign, readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic, readwrite, copy) NSString *title;
@property (nonatomic, strong, readwrite) AZZHongBaoModel *model;
@property (nonatomic, copy, readwrite) NSArray<AZZHongBaoModel *> *models;

@end

@implementation AZZMapAnnotation

+ (AZZMapAnnotation *)annotationWithModel:(AZZHongBaoModel *)model {
    AZZMapAnnotation *instance = [[AZZMapAnnotation alloc] init];
    NSString *title = @"";
    if (model.message) {
        title = model.message;
    }
    instance.title = title;
    instance.coordinate = CLLocationCoordinate2DMake(model.latitude, model.longitude);
    instance.model = model;
    return instance;
}

+ (AZZMapAnnotation *)annotationWithLocation:(CLLocation *)location models:(NSArray<AZZHongBaoModel *> *)models {
    AZZMapAnnotation *instance = [[AZZMapAnnotation alloc] init];
    instance.title = @"";
    instance.coordinate = location.coordinate;
    instance.models = models;
    return instance;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    _coordinate = newCoordinate;
}

+ (AZZMapAnnotation *)annotationWithTitle:(NSString *)title coor:(CLLocationCoordinate2D)coor {
    AZZMapAnnotation *instance = [[AZZMapAnnotation alloc] init];
    instance.title = title;
    instance.coordinate = coor;
    return instance;
}

@end
