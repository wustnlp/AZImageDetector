//
//  AZZClient.h
//  LogoDetector
//
//  Created by 朱安智 on 2017/1/13.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "AZZServerResources.h"

@class AZZHongBaoModel, AZZClient;

#define AZZClientInstance [AZZClient sharedInstance]

typedef void(^AZZClientSuccess)(NSHTTPURLResponse * _Nullable response, id _Nullable responseObject);
typedef void(^AZZClientFail)(NSHTTPURLResponse * _Nullable response, id _Nullable responseObject, NSError * _Nullable error);

@interface AZZClient : AFHTTPSessionManager

+ (nonnull AZZClient *)sharedInstance;

- (nullable NSURLSessionDataTask *)requestUploadHongBaoWith:(nonnull NSData *)image
                                                     userId:(nonnull NSString *)userId
                                                       cost:(nonnull NSString *)cost
                                                     amount:(nonnull NSString *)amount
                                                   latitude:(nonnull NSString *)latitude
                                                  longitude:(nonnull NSString *)longitude
                                                    success:(nullable void (^)(NSString * _Nullable msg))success
                                                       fail:(void (^ _Nullable)(NSString * _Nullable msg, NSError * _Nullable error))fail;

- (nullable NSURLSessionDataTask *)requestRelatedHongBaoWithLatitude:(nonnull NSString *)latitude
                                                           longitude:(nonnull NSString *)longitude
                                                             success:(nullable void (^)(NSArray<AZZHongBaoModel *> * _Nullable arrHongBao))success
                                                                fail:(nullable void (^)(NSString * _Nullable msg, NSError * _Nullable error))fail ;

- (nullable NSURLSessionDataTask *)requestGetHongWithUUID:(nonnull NSString *)uuid
                                               BaoSuccess:(nullable void (^)(NSString * _Nullable msg))success
                                                     fail:(nullable void (^)(NSString * _Nullable msg, NSError * _Nullable error))fail;

@end