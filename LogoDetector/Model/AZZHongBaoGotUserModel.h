//
//  AZZHongBaoGotUserModel.h
//  LogoDetector
//
//  Created by 朱安智 on 2017/1/19.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface AZZHongBaoGotUserModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, assign, readonly) float gotcost;
@property (nonatomic, copy, readonly) NSString *hongbaoid;
@property (nonatomic, copy, readonly) NSString *idString;
@property (nonatomic, copy, readonly) NSString *username;

+ (instancetype)getGotUserModelWithJSONDictionary:(NSDictionary *)dic;
+ (NSArray<AZZHongBaoGotUserModel *> *)getGotUserModelsWithJSONArray:(NSArray *)arr;

@end
