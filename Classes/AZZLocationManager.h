//
//  AZZLocationManager.h
//  LogoDetector
//
//  Created by 朱安智 on 2017/1/10.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface AZZLocationManager : NSObject

+ (AZZLocationManager *)sharedInstance;
- (void)startUpdatingLocationWithBlock:(void (^)(NSArray<CLLocation *> *locations))block placeCallback:(void (^)(NSArray<CLPlacemark *> *placeMarks))placeBlock;
- (void)stopUpdatingLocation;

@end
