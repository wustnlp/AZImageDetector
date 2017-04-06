//
//  AZZHongbaoAnnotationView.h
//  LogoDetector
//
//  Created by 朱安智 on 2017/4/1.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import <MapKit/MapKit.h>

@class AZZHongBaoModel, AZZMapAnnotation;

typedef void(^HongBaoAnnotationClickedCallback)(AZZHongBaoModel *model);

@interface AZZHongbaoAnnotationView : MKAnnotationView

@property (nonatomic, copy) HongBaoAnnotationClickedCallback callback;

+ (AZZHongbaoAnnotationView *)annotationViewWithMapView:(MKMapView *)mapView annotation:(AZZMapAnnotation *)annotation;

@end
