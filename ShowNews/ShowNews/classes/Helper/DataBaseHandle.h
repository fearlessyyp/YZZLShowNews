//
//  DataBaseHandle.h
//  ShowNews
//
//  Created by YYP on 16/7/2.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "User.h"
#import <AVOSCloud/AVOSCloud.h>
#import "News.h"
#import "VideoModel.h"
#import "Music.h"
#import "User.h"

@interface DataBaseHandle : NSObject

#pragma mark - 声明单例
singleton_interface(DataBaseHandle)


#pragma mark - 用户
#pragma mark - 用户电话号码注册
- (void)registerUserWithPhone:(User *)user;

#pragma mark - 用户邮箱注册
- (void)registerUserWithEmail:(User *)user;

#pragma mark - 通过邮箱找回密码
/**
 *  用户输入注册的电子邮件，请求重置密码；
 LeanStorage 向该邮箱发送一封包含重置密码的特殊链接的电子邮件；
 用户点击重置密码链接后，一个特殊的页面会打开，让他们输入新密码；
 用户的密码已被重置为新输入的密码。
 *
 *  @param email <#email description#>
 */
- (void)findPasswordWithEmail:(NSString *)email;


#pragma mark - 通过手机号码验证码找回密码
- (void)findPasswordWithPhone:(NSString *)phone;
#pragma mark - 输入验证码和新的密码重置密码
- (void)resetPasswordWithCode:(NSString *)code
                  newPassword:(NSString *)newPassword;


#pragma mark - 用户名密码 登录
- (void)loginWithUserName:(NSString *)userName
                 password:(NSString *)password;
#pragma mark - 手机号码 密码登录
- (void)loginWithPhone:(NSString *)phone
              password:(NSString *)password;

//#pragma mark - 手机号码动态验证码登录
//// 发送验证码
//- (void)loginSendCodeWithPhone:(NSString *)phone;
//// 验证验证码
//- (void)loginCheckWithPhone:(NSString *)phone
//                   password:(NSString *)password;

#pragma mark - 判断当前用户是否登录
- (BOOL)userIsLogin;

#pragma mark - 登出注销
- (BOOL)userLogout;

#pragma mark - News转换成AVObject
- (AVObject *)newsToAVObject:(News *)news;
#pragma mark - AVObject转换成转换成
- (News *)aVObjectToNews:(AVObject *)object;

#pragma mark - Video转换成AVObject
- (AVObject *)videoToAVObject:(VideoModel *)video;

#pragma mark - Music转换成AVObject
- (AVObject *)musicTOAVObject:(Music *)music;

#pragma mark - User转换成AVObject
- (AVObject *)userToAVObject:(User *)user;


@end
