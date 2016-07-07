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



#pragma mark - News转换成AVObject
- (AVObject *)newsToAVObject:(News *)news;
#pragma mark - AVObject转换成转换成
- (News *)aVObjectToNews:(AVObject *)object;

#pragma mark - Video转换成AVObject
- (AVObject *)videoToAVObject:(VideoModel *)video;

#pragma mark -AVObject转换成Video
- (VideoModel *)aVObjectToVideoModel:(AVObject *)object;

#pragma mark - Music转换成AVObject
- (AVObject *)musicTOAVObject:(Music *)music;

- (Music *)aVObjectToMusic:(AVObject *)object;



@end
