//
//  User.m
//  ShowNews
//
//  Created by YYP on 16/7/2.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithUserName:(NSString *)username
                        password:(NSString *)password
                           phone:(NSString *)phone
                           email:(NSString *)email
                           image:(NSData *)image {
    if (self = [super init]) {
        self.username = username;
        self.password = password;
        self.phone = phone;
        self.email = email;
        self.image = image;
    }
    return self;
}

+ (instancetype)userWithUserName:(NSString *)username
                        password:(NSString *)password
                           phone:(NSString *)phone
                           email:(NSString *)email
                           image:(NSData *)image {
    
    return [[User alloc] initWithUserName:username password:password phone:phone email:email image:image];
}




@end
