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

@end

@implementation AZZMapAnnotation

+ (AZZMapAnnotation *)annotationWithModel:(AZZHongBaoModel *)model {
    AZZMapAnnotation *instance = [[AZZMapAnnotation alloc] init];
    instance.title = [@(model.cost) stringValue];
    instance.coordinate = CLLocationCoordinate2DMake(model.latitude, model.longitude);
    instance.model = model;
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
