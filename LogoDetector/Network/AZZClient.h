//
//  AZZClient.h
//  LogoDetector
//
//  Created by 朱安智 on 2017/1/13.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "AZZServerResources.h"

@class AZZHongBaoModel, AZZClient, AZZHongBaoGotUserModel;

#define AZZClientInstance [AZZClient sharedInstance]

typedef void(^AZZClientSuccess)(NSHTTPURLResponse * _Nullable response, id _Nullable responseObject);
typedef void(^AZZClientFail)(NSHTTPURLResponse * _Nullable response, id _Nullable responseObject, NSError * _Nullable error);

@interface AZZClient : AFHTTPSessionManager

@property (nonatomic, strong, readonly) NSString * _Nullable userName;

+ (nonnull AZZClient *)sharedInstance;

- (nullable NSURLSessionDataTask *)requestRegisterWithUsername:(nonnull NSString *)userName
                                                      password:(nonnull NSString *)password
                                                       success:(nullable void (^)(NSString * _Nullable msg, id _Nullable userid))success
                                                          fail:(nullable void (^)(NSString * _Nullable msg, NSError * _Nullable error))fail;

- (nullable NSURLSessionDataTask *)requestLoginWithUsername:(nonnull NSString *)userName
                                                   password:(nonnull NSString *)password
                                                    success:(nullable void (^)(NSString * _Nullable msg, id _Nullable userid))success
                                                       fail:(nullable void (^)(NSString * _Nullable msg, NSError * _Nullable error))fail;

- (nullable NSURLSessionDataTask *)requestUploadHongBaoWith:(nonnull NSData *)image
                                                       cost:(nonnull NSString *)cost
                                                     amount:(nonnull NSString *)amount
                                                   latitude:(nonnull NSString *)latitude
                                                  longitude:(nonnull NSString *)longitude
                                                    message:(nullable NSString *)message
                                                    success:(nullable void (^)(NSString * _Nullable msg))success
                                                       fail:(void (^ _Nullable)(NSString * _Nullable msg, NSError * _Nullable error))fail;

- (nullable NSURLSessionDataTask *)requestRelatedHongBaoWithLatitude:(nonnull NSString *)latitude
                                                           longitude:(nonnull NSString *)longitude
                                                             success:(nullable void (^)(NSArray<AZZHongBaoModel *> * _Nullable arrHongBao))success
                                                                fail:(nullable void (^)(NSString * _Nullable msg, NSError * _Nullable error))fail ;

- (nullable NSURLSessionDataTask *)requestGetHongWithUUID:(nonnull NSString *)uuid
                                               BaoSuccess:(nullable void (^)(NSString * _Nullable msg, id _Nullable obj))success
                                                     fail:(nullable void (^)(NSString * _Nullable msg, NSError * _Nullable error))fail;

- (nullable NSURLSessionDataTask *)requestGetGotUsersWithHongbaoID:(nonnull NSString *)hongbaoId
                                                           success:(nullable void (^)(NSArray<AZZHongBaoGotUserModel *> * _Nullable users))success
                                                              fail:(nullable void (^)(NSString * _Nullable msg, NSError * _Nullable error))fail;

- (nullable NSURLSessionDataTask *)requestGetAmountSuccess:(nullable void (^)(NSInteger result))success
                                                      fail:(nullable void (^)(NSString * _Nullable msg, NSError * _Nullable error))fail;

- (nullable NSURLSessionDataTask *)requestUseHongbaoWithAmount:(NSInteger)amount
                                                       success:(nullable void (^)(NSString * _Nonnull type, NSString * _Nonnull value))success
                                                          fail:(nullable void (^)(NSString * _Nullable msg, NSError * _Nullable error))fail;

@end
