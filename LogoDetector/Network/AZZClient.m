//
//  AZZClient.m
//  LogoDetector
//
//  Created by 朱安智 on 2017/1/13.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import "AZZClient.h"
#import "AZZHongBaoModel.h"

@interface AZZClient ()

@property (nonatomic, strong) AFJSONRequestSerializer *postSerializer;

@end

@implementation AZZClient

+ (AZZClient *)sharedInstance {
    static AZZClient *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AZZClient alloc] initWithBaseURL:[NSURL URLWithString:AZZServerAddress]];
        instance.postSerializer = [AFJSONRequestSerializer serializer];
        instance.requestSerializer = [AFHTTPRequestSerializer serializer];
        instance.responseSerializer = [AFJSONResponseSerializer serializer];
        instance.postSerializer.timeoutInterval = 30;
        instance.requestSerializer.timeoutInterval = 15;
    });
    return instance;
}

- (NSURLSessionDataTask *)requestWithURL:(NSString *)url
                                  method:(NSString *)method
                              parameters:(NSDictionary *)param
                                 success:(AZZClientSuccess)success
                                    fail:(AZZClientFail)fail {
    
    NSError *error = nil;
    AFHTTPRequestSerializer *serializer = self.requestSerializer;
    if ([method isEqualToString:@"POST"]) {
        serializer = self.postSerializer;
    }
    NSURLRequest *request = [serializer requestWithMethod:method URLString:[NSURL URLWithString:url relativeToURL:self.baseURL].absoluteString parameters:param error:&error];
    
    if (error) {
        if (fail) {
            dispatch_async(dispatch_get_main_queue(), ^{
                fail(nil, nil, error);
            });
        }
        return nil;
    }
    
    NSURLSessionDataTask *dataTask = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            if (fail) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    fail((NSHTTPURLResponse *)response, responseObject, error);
                });
            }
        } else {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    success((NSHTTPURLResponse *)response, responseObject);
                });
            }
        }
    }];
    [dataTask resume];
    return dataTask;
}

- (NSURLSessionDataTask *)requestUploadHongBaoWith:(NSData *)image
                                            userId:(NSString *)userId
                                              cost:(NSString *)cost
                                            amount:(NSString *)amount
                                          latitude:(NSString *)latitude
                                         longitude:(NSString *)longitude
                                           success:(void (^)(NSString * _Nullable msg))success
                                              fail:(void (^)(NSString * _Nullable msg, NSError * _Nullable error))fail {
    NSDictionary *param = @{
                            @"userid"    : userId,
                            @"cost"      : cost,
                            @"amount"    : amount,
                            @"latitude"  : latitude,
                            @"longitude" : longitude,
                            };
    NSError *error = nil;
    NSURLRequest *request = [self.postSerializer multipartFormRequestWithMethod:@"POST" URLString:[NSURL URLWithString:@"upload.do" relativeToURL:self.baseURL].absoluteString parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:image name:@"file" fileName:@"image.png" mimeType:@"image/png"];
    } error:&error];
    
    if (error) {
        if (fail) {
            dispatch_async(dispatch_get_main_queue(), ^{
                fail(nil, error);
            });
        }
        return nil;
    }
    
    NSURLSessionDataTask *dataTask = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSString *msg = nil;
        BOOL boolSuccess = NO;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            msg = [responseObject objectForKey:@"msg"];
            boolSuccess = [[responseObject objectForKey:@"success"] boolValue];
        }
        if (error || !boolSuccess) {
            if (fail) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    fail(msg, error);
                });
            }
        } else {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(msg);
                });
            }
        }
    }];
    [dataTask resume];
    return dataTask;
}

- (nullable NSURLSessionDataTask *)requestRelatedHongBaoWithLatitude:(nonnull NSString *)latitude
                                                            longitude:(nonnull NSString *)longitude
                                                              success:(nullable void (^)(NSArray<AZZHongBaoModel *> * _Nullable arrHongBao))success
                                                                 fail:(nullable void (^)(NSString * _Nullable msg, NSError * _Nullable error))fail {
    NSDictionary *param = @{
                            @"longitude" : longitude,
                            @"latitude"  : latitude,
                            };
    return [self requestWithURL:@"getRelated.do" method:@"GET" parameters:param success:^(NSHTTPURLResponse * _Nullable response, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSString *msg = [responseObject objectForKey:@"msg"];
            NSNumber *boolNum = [responseObject objectForKey:@"success"];
            if (boolNum && ![boolNum boolValue] && fail) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    fail(msg, nil);
                });
            }
        } else {
            if (success) {
                NSArray *jsons = [responseObject objectForKey:@"rows"];
                NSArray *models = [AZZHongBaoModel hongBaoModelsFromArray:jsons];
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(models);
                });
            }
        }
    } fail:^(NSHTTPURLResponse * _Nullable response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (fail) {
            dispatch_async(dispatch_get_main_queue(), ^{
                fail(nil, error);
            });
        }
    }];
}

- (nullable NSURLSessionDataTask *)requestGetHongWithUUID:(nonnull NSString *)uuid
                                               BaoSuccess:(nullable void (^)(NSString * _Nullable msg))success
                                                     fail:(nullable void (^)(NSString * _Nullable msg, NSError * _Nullable error))fail {
    NSDictionary *param = @{
                            @"uuid" : uuid,
                            };
    return [self requestWithURL:@"getHongbao.do" method:@"GET" parameters:param success:^(NSHTTPURLResponse * _Nullable response, id  _Nullable responseObject) {
        NSString *msg = nil;
        BOOL boolSuccess = NO;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            msg = [responseObject objectForKey:@"msg"];
            boolSuccess = [[responseObject objectForKey:@"success"] boolValue];
        }
        if (boolSuccess) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(msg);
                });
            }
        } else {
            if (fail) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    fail(msg, nil);
                });
            }
        }
    } fail:^(NSHTTPURLResponse * _Nullable response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (fail) {
            dispatch_async(dispatch_get_main_queue(), ^{
                fail(nil, error);
            });
        }
    }];
}

@end
