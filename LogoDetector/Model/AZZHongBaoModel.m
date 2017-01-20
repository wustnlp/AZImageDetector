//
//  AZZHongBaoModel.m
//  LogoDetector
//
//  Created by 朱安智 on 2017/1/13.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import "AZZHongBaoModel.h"

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

@end
