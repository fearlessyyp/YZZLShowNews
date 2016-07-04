//
//  VideoModel.h
//  ShowNews
//
//  Created by LK on 16/6/24.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoModel : NSObject
// / 标题
@property (nonatomic, strong) NSString *title;
// / 视频缩略图
@property (nonatomic, strong) NSString *cover;

// / 视频长度 单位：秒
@property (nonatomic, assign) NSInteger length;

// /视频链接
@property (nonatomic, strong) NSString *mp4_url;

// /视频发布者
@property (nonatomic, strong) NSString *topicName;

// /视频发布者头像
@property (nonatomic, strong) NSString *topicImg;

@property (nonnull, copy) NSString *topicSid;

@end
