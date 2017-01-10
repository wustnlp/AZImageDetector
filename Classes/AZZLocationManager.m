//
//  AZZLocationManager.m
//  LogoDetector
//
//  Created by 朱安智 on 2017/1/10.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import "AZZLocationManager.h"

typedef void(^AZZLocationCallBack)(NSArray<CLLocation *> *);
typedef void(^AZZPlaceCallBack)(NSArray<CLPlacemark *> *);

@interface AZZLocationManager () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, copy) AZZLocationCallBack callback;
@property (nonatomic, copy) AZZPlaceCallBack placeCallback;

@end

@implementation AZZLocationManager

+ (AZZLocationManager *)sharedInstance {
    static AZZLocationManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AZZLocationManager alloc] init];
    });
    return instance;
}

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [_locationManager requestWhenInUseAuthorization];
        [_locationManager requestAlwaysAuthorization];
    }
    return _locationManager;
}

- (void)startUpdatingLocationWithBlock:(void (^)(NSArray<CLLocation *> *locations))block placeCallback:(void (^)(NSArray<CLPlacemark *> *placeMarks))placeBlock {
    self.callback = block;
    self.placeCallback = placeBlock;
    [self.locationManager startUpdatingLocation];
}

- (void)stopUpdatingLocation {
    [self.locationManager stopUpdatingLocation];
}

#pragma mark - LocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    self.callback(locations);
    for (CLLocation *location in locations) {
        CLGeocoder *coder = [[CLGeocoder alloc] init];
        [coder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            self.placeCallback(placemarks);
        }];
    }
}

@end
