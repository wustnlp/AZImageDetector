//
//  AZZLocationManager.m
//  LogoDetector
//
//  Created by 朱安智 on 2017/1/10.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import "AZZLocationManager.h"
#import <JZLocationConverter/JZLocationConverter.h>

typedef void(^AZZLocationCallBack)(NSArray<CLLocation *> *);
typedef void(^AZZPlaceCallBack)(NSArray<CLPlacemark *> *);

@interface AZZLocationManager () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, copy) AZZLocationCallBack callback;
@property (nonatomic, copy) AZZPlaceCallBack placeCallback;
@property (nonatomic, strong, readwrite) CLLocation *currentLocation;

@property (nonatomic, copy) void (^getLocationBlock)(CLLocation *location);
@property (nonatomic, copy) void (^getCoordinateBlock)(CLLocationCoordinate2D coor);

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

- (void)getCurrentLocationWithBlock:(void (^)(CLLocation *location))block {
    [self.locationManager startUpdatingLocation];
    if (self.currentLocation) {
        block(self.currentLocation);
    } else {
        self.getLocationBlock = block;
    }
}

- (void)getCurrentGCJCoordinateWithBlock:(void (^)(CLLocationCoordinate2D location))block {
    [self.locationManager startUpdatingLocation];
    if (self.currentLocation) {
        CLLocationCoordinate2D before = self.currentLocation.coordinate;
        CLLocationCoordinate2D after = [JZLocationConverter wgs84ToGcj02:before];
        block(after);
    } else {
        self.getCoordinateBlock = block;
    }
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
    self.currentLocation = locations.firstObject;
    if (self.getLocationBlock) {
        self.getLocationBlock(locations.firstObject);
        self.getLocationBlock = nil;
    }
    if (self.getCoordinateBlock) {
        CLLocationCoordinate2D before = self.currentLocation.coordinate;
        CLLocationCoordinate2D after = [JZLocationConverter wgs84ToGcj02:before];
        self.getCoordinateBlock(after);
        self.getCoordinateBlock = nil;
    }
    if (self.callback) {
        self.callback(locations);
    }
    for (CLLocation *location in locations) {
        CLGeocoder *coder = [[CLGeocoder alloc] init];
        [coder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (self.placeCallback) {
                self.placeCallback(placemarks);
            }
        }];
    }
}

@end
