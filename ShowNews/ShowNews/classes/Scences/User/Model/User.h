//
//  User.h
//  ShowNews
//
//  Created by YYP on 16/7/2.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
/// 用户名
@property (nonatomic, strong) NSString *username;
/// 密码
@property (nonatomic, strong) NSString *password;
/// 电话号码
@property (nonatomic, strong) NSString *phone;
/// 邮箱
@property (nonatomic, strong) NSString *email;
/// 头像
@property (nonatomic, strong) NSData *image;
/// ID
@property (nonatomic, strong) NSString *Id;

- (instancetype)initWithUserName:(NSString *)username
                        password:(NSString *)password
                           phone:(NSString *)phone
                           email:(NSString *)email
                           image:(NSData *)image;

+ (instancetype)userWithUserName:(NSString *)username
                        password:(NSString *)password
                           phone:(NSString *)phone
                           email:(NSString *)email
                           image:(NSData *)image;

@end
