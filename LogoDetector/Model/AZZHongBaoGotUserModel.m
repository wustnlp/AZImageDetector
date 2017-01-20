//
//  AZZHongBaoGotUserModel.m
//  LogoDetector
//
//  Created by 朱安智 on 2017/1/19.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import "AZZHongBaoGotUserModel.h"

@implementation AZZHongBaoGotUserModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"gotcost"   : @"gotcost",
             @"hongbaoid" : @"hongbaoid",
             @"idString"  : @"id",
             @"username"  : @"username",
             };
}

+ (instancetype)getGotUserModelWithJSONDictionary:(NSDictionary *)dic {
    NSError *error = nil;
    id result = [MTLJSONAdapter modelOfClass:[self class] fromJSONDictionary:dic error:&error];
    if (error) {
        NSLog(@"get model with dic:%@ error:%@", dic, error.localizedDescription);
    }
    return result;
}

+ (NSArray<AZZHongBaoGotUserModel *> *)getGotUserModelsWithJSONArray:(NSArray *)arr {
    NSError *error = nil;
    NSArray *result = [MTLJSONAdapter modelsOfClass:[self class] fromJSONArray:arr error:&error];
    if (error) {
        NSLog(@"get models with arr:%@ error:%@", arr, error.localizedDescription);
    }
    return result;
}

@end
