//
//  AZZHongBaoModel.m
//  LogoDetector
//
//  Created by 朱安智 on 2017/1/13.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import "AZZHongBaoModel.h"
#import <CoreLocation/CoreLocation.h>

@implementation AZZHongBaoModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"cost"         : @"cost",
             @"idString"     : @"id",
             @"userid"       : @"userid",
             @"latitude"     : @"latitude",
             @"longitude"    : @"longitude",
             @"remainAmount" : @"remainAmount",
             @"remainCost"   : @"remainCost",
             @"amount"       : @"amount",
             @"message"      : @"message",
             };
}

+ (instancetype)hongBaoModelFromDictionary:(NSDictionary *)dic {
    NSError *error = nil;
    id result = [MTLJSONAdapter modelOfClass:[self class] fromJSONDictionary:dic error:&error];
    if (error) {
        NSLog(@"get %@ model from:%@ error:%@", self.class, dic, error.localizedDescription);
    }
    return result;
}

+ (NSArray<AZZHongBaoModel *> *)hongBaoModelsFromArray:(NSArray *)arr {
    NSError *error = nil;
    NSArray *result = [MTLJSONAdapter modelsOfClass:[self class] fromJSONArray:arr error:&error];
    if (error) {
        NSLog(@"get %@ models from:%@ error:%@", self.class, arr, error.localizedDescription);
    }
    return result;
}

- (BOOL)sameLocationWithModel:(AZZHongBaoModel *)model {
    return (self.latitude == model.latitude) && (self.longitude == model.longitude);
}

+ (NSDictionary<NSString *, NSArray<AZZHongBaoModel *> *> *)modelWithLocations:(NSArray<AZZHongBaoModel *> *)models {
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    for (AZZHongBaoModel *model in models) {
        NSString *location = [NSString stringWithFormat:@"%.4fX%.4f", model.latitude, model.longitude];
//        CLLocation *location = [[CLLocation alloc] initWithLatitude:model.latitude longitude:model.longitude];
        NSArray *array = [tempDic objectForKey:location];
        if (!array) {
            array = [NSArray array];
        }
        NSMutableArray *marray = array.mutableCopy;
        [marray addObject:model];
        [tempDic setObject:marray.copy forKey:location];
    }
    return tempDic.copy;
}

@end
