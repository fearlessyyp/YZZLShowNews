//
//  DataBaseHandle.m
//  ShowNews
//
//  Created by YYP on 16/7/2.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import "DataBaseHandle.h"



typedef NS_ENUM(NSUInteger, NewsType) {
    NewsTypePhotoSet,
    NewsTypeSpecial,
    NewsTypeArticle,
    NewsTypeUnknow,
};



@implementation DataBaseHandle
#pragma mark - 声明单例
singleton_implementation(DataBaseHandle)


#pragma mark - 用户
#pragma mark - 用户电话号码注册
- (void)registerUserWithPhone:(User *)user {
    
}

#pragma mark - 用户邮箱注册
- (void)registerUserWithEmail:(User *)user {
    
}

#pragma mark - 通过邮箱找回密码
/**
 *  用户输入注册的电子邮件，请求重置密码；
 LeanStorage 向该邮箱发送一封包含重置密码的特殊链接的电子邮件；
 用户点击重置密码链接后，一个特殊的页面会打开，让他们输入新密码；
 用户的密码已被重置为新输入的密码。
 *
 *  @param email <#email description#>
 */
- (void)findPasswordWithEmail:(NSString *)email {
    
}


#pragma mark - 通过手机号码验证码找回密码
- (void)findPasswordWithPhone:(NSString *)phone {
    
}

#pragma mark - 输入验证码和新的密码重置密码
- (void)resetPasswordWithCode:(NSString *)code
                  newPassword:(NSString *)newPassword {
    
}


#pragma mark - 用户名密码 登录
- (void)loginWithUserName:(NSString *)userName
                 password:(NSString *)password {
    
}
#pragma mark - 手机号码 密码登录
- (void)loginWithPhone:(NSString *)phone
              password:(NSString *)password {
    
}
//
//#pragma mark - 手机号码动态验证码登录
//// 发送验证码
//- (void)loginSendCodeWithPhone:(NSString *)phone {
//    
//}
//// 验证验证码
//- (void)loginCheckWithPhone:(NSString *)phone
//                   password:(NSString *)password {
//    
//}

#pragma mark - 判断当前用户是否登录
- (BOOL)userIsLogin {
    AVUser *currentUser = [AVUser currentUser];
    if (currentUser != nil) {
        // 跳转到首页
        return YES;
    } else {
        //缓存用户对象为空时，可打开用户注册界面…
        return NO;
    }
}

#pragma mark - 登出注销
- (BOOL)userLogout {
    [AVUser logOut];  //清除缓存用户对象
    AVUser *currentUser = [AVUser currentUser]; // 现在的currentUser是nil了
    if (currentUser == nil) {
        // 登出成功
        return YES;
    } else {
        // 登出失败
        return NO;
    }
}

#pragma mark - News转换成AVObject
- (AVObject *)newsToAVObject:(News *)news {
    AVObject *ob = [[AVObject alloc] initWithClassName:@"News"];
    [ob setObject:news.postid forKey:@"postid"];
    [ob setObject:news.title forKey:@"title"];
    [ob setObject:news.skipID forKey:@"skipID"];
    [ob setObject:news.skipType forKey:@"skipType"];
    [ob setObject:news.imgsrc forKey:@"imgsrc"];
    [ob setObject:news.source forKey:@"source"];
    [ob setObject:@1 forKey:@"username"];
    return ob;
}

#pragma mark - AVObject转换成转换成
- (News *)aVObjectToNews:(AVObject *)object {
    News *news = [[News alloc] init];
    news.postid = [object objectForKey:@"postid"];
    news.title = [object objectForKey:@"title"];
    news.skipID = [object objectForKey:@"skipID"];
    news.skipType = [object objectForKey:@"skipType"];
    news.imgsrc = [object objectForKey:@"imgsrc"];
    return news;
}

#pragma mark - 返回新闻类型
- (NewsType)newsTypeWithNews:(News *)news {
    if (news.skipType == nil) {
        return NewsTypeArticle;
    } else if ([news.skipType isEqualToString:@"special"]) {
        return NewsTypeSpecial;
    } else if ([news.skipType isEqualToString:@"photoset"]) {
        return NewsTypePhotoSet;
    }
    return NewsTypeUnknow;
}

#pragma mark - Video转换成AVObject
- (AVObject *)videoToAVObject:(VideoModel *)video {
    AVObject *ob = [[AVObject alloc] init];
    [ob setObject:video.title forKey:@"title"];
    [ob setObject:video.cover forKey:@"cover"];
    [ob setObject:@(video.length) forKey:@"length"];
    [ob setObject:video.mp4_url forKey:@"mp4_url"];
    [ob setObject:video.topicName forKey:@"topicName"];
    [ob setObject:video.topicImg forKey:@"topicImg"];
    return ob;
}

#pragma mark - Music转换成AVObject
- (AVObject *)musicTOAVObject:(Music *)music {
    AVObject *ob = [[AVObject alloc] init];
    
    return ob;
}

//#pragma mark - User转换成AVObject
//- (AVObject *)userToAVObject:(User *)user {
//    AVUser
//}

@end
