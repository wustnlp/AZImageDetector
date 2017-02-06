//
//  AZZMapViewController.m
//  LogoDetector
//
//  Created by 朱安智 on 2017/1/13.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import "AZZMapViewController.h"
#import "AZZClient.h"
#import "AZZLocationManager.h"
#import "AZZScanHongBaoViewController.h"

#import "AZZHongBaoModel.h"
#import "AZZMapAnnotation.h"

#import <Masonry/Masonry.h>
#import <MapKit/MapKit.h>

@interface AZZMapViewController () <MKMapViewDelegate>

@property (nonatomic, strong) MKMapView *mapView;

@property (nonatomic, copy) NSArray<AZZMapAnnotation *> *arrAnnotations;

@end

@implementation AZZMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [AZZLocationManagerInstance getCurrentGCJCoordinateWithBlock:^(CLLocationCoordinate2D location) {
        [self locationUpdate:location];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)locationUpdate:(CLLocationCoordinate2D)location {
    NSString *latitude = [@(location.latitude) stringValue];
    NSString *longitude = [@(location.longitude) stringValue];
    self.mapView.region = MKCoordinateRegionMake(location, MKCoordinateSpanMake(0.01, 0.01));
    self.mapView.showsUserLocation = YES;
    NSLog(@"cl user lati:%@ longi:%@", latitude, longitude);
    [AZZClientInstance requestRelatedHongBaoWithLatitude:latitude longitude:longitude success:^(NSArray<AZZHongBaoModel *> * _Nullable arrHongBao) {
        NSMutableArray *annotations = [NSMutableArray array];
        for (AZZHongBaoModel *model in arrHongBao) {
            AZZMapAnnotation *annotation = [AZZMapAnnotation annotationWithModel:model];
            [annotations addObject:annotation];
        }
        self.arrAnnotations = annotations;
        [self.mapView removeAnnotations:self.mapView.annotations];
        [self.mapView addAnnotations:self.arrAnnotations];
    } fail:^(NSString * _Nullable msg, NSError * _Nullable error) {
        NSMutableString *reason = [NSMutableString string];
        if (msg) {
            [reason appendFormat:@"Message from server: %@", msg];
            if (error) {
                [reason appendString:@"\n"];
            }
        }
        if (error) {
            [reason appendFormat:@"domain:%@ code:%@ description:%@", error.domain, @(error.code), error.localizedDescription];
        }
        [self showHudWithTitle:@"Error" detail:[reason copy] hideAfterDelay:3.f];
    }];
}

- (void)setupConstraints {
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(64.f);
        make.left.and.right.and.bottom.equalTo(self.view);
    }];
}

#pragma mark - Property

- (MKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[MKMapView alloc] init];
        _mapView.delegate = self;
        [self.view addSubview:_mapView];
    }
    return _mapView;
}

#pragma mark - MapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if (annotation == mapView.userLocation) {
        return nil;
    }
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"HongBao"];
    if (!annotationView) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"HongBao"];
        CGRect frame = annotationView.frame;
        frame.size = CGSizeMake(40, 40);
        annotationView.frame = frame;
        annotationView.image = [UIImage imageNamed:@"hongbao_annotation"];
    }
    annotationView.draggable = NO;
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    NSString *latitude = [@(userLocation.coordinate.latitude) stringValue];
    NSString *longitude = [@(userLocation.coordinate.longitude) stringValue];
    NSLog(@"mk user lati:%@ longi:%@", latitude, longitude);
    [mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    AZZMapAnnotation *annotation = view.annotation;
    if ((id)annotation == mapView.userLocation) {
        return;
    }
    
    AZZScanHongBaoViewController *vc = [AZZScanHongBaoViewController new];
    vc.model = annotation.model;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
