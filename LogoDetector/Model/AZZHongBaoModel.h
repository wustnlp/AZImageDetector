//
//  AZZHongBaoModel.h
//  LogoDetector
//
//  Created by 朱安智 on 2017/1/13.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface AZZHongBaoModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, assign, readonly) double cost;
@property (nonatomic, copy, readonly) NSString *idString;
@property (nonatomic, copy, readonly) NSString *userid;
@property (nonatomic, assign, readonly) double latitude;
@property (nonatomic, assign, readonly) double longitude;
@property (nonatomic, assign, readonly) NSInteger remainAmount;
@property (nonatomic, assign, readonly) float remainCost;
@property (nonatomic, assign, readonly) NSInteger amount;

+ (instancetype)hongBaoModelFromDictionary:(NSDictionary *)dic;
+ (NSArray<AZZHongBaoModel *> *)hongBaoModelsFromArray:(NSArray *)arr;

@end
