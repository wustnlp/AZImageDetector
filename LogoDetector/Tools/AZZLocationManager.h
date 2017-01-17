//
//  AZZLocationManager.h
//  LogoDetector
//
//  Created by 朱安智 on 2017/1/10.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class AZZLocationManager;

#define AZZLocationManagerInstance [AZZLocationManager sharedInstance]

@interface AZZLocationManager : NSObject

@property (nonatomic, strong, readonly) CLLocation *currentLocation;

+ (AZZLocationManager *)sharedInstance;
- (void)startUpdatingLocationWithBlock:(void (^)(NSArray<CLLocation *> *locations))block placeCallback:(void (^)(NSArray<CLPlacemark *> *placeMarks))placeBlock;
- (void)stopUpdatingLocation;
- (void)getCurrentLocationWithBlock:(void (^)(CLLocation *location))block;
- (void)getCurrentGCJCoordinateWithBlock:(void (^)(CLLocationCoordinate2D location))block;

@end
