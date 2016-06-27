//
//  RequestHelper.m
//  WXPlayer
//
//  Created by lanou3g on 16/6/15.
//  Copyright © 2016年 wxerters. All rights reserved.
//

#import "RequestHelper.h"

@implementation RequestHelper

- (void)requestWithUrl:(NSString *)url WithSuccessBlock:(void (^)(id))successBlock failBlock:(void (^)(NSError *))failBlock{
    if (!url) {
        if (failBlock) {
            NSError *err = [NSError errorWithDomain:@"url为空" code:1 userInfo:nil];
            failBlock(err);
        }
        return;
    }
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error && data) {
            NSError *err = nil;
            id responData = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:&err];
            if(!err && responData && successBlock){
                dispatch_async(dispatch_get_main_queue(), ^{
                    successBlock(responData);
                });
            }else{
                if (failBlock) {
                    NSError *err = [NSError errorWithDomain:@"解析出错" code:1 userInfo:nil];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        failBlock(err);
                    });
                }
            }
        }else{
            if (failBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    failBlock(error);
                });
            }
        }
    }];
    [dataTask resume];
}

@end
