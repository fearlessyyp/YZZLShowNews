//
//  RequestHelper.h
//  WXPlayer
//
//  Created by lanou3g on 16/6/15.
//  Copyright © 2016年 wxerters. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestHelper : NSObject

- (void)requestWithUrl: (NSString *)url WithSuccessBlock: (void(^)(id data))successBlock failBlock: (void(^)(NSError *err))failBlock;

@end
