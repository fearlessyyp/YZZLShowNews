//
//  Music.h
//  ShowNews
//
//  Created by ZZQ on 16/6/25.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Music : NSObject

@property (nonatomic, strong) NSString * lyricxxxx;  // 歌词
// 歌曲
@property (nonatomic, copy) NSString *musicName;
// 歌手
@property (nonatomic, copy) NSString *singerName;
// 专辑
@property (nonatomic, copy) NSString *specialName;
// ID
@property (nonatomic, copy) NSString *ID;

@property (nonatomic, strong) NSString * mp3Url;       // 歌曲的Url

@property (nonatomic, strong) NSString * picUrl;       // 歌曲的图片Url

// 时间
@property (nonatomic, strong) NSString * duration;     // 歌曲的时长

// 判断是否收藏
@property (nonatomic, assign) BOOL IsCollect;

// 表的主键
@property (nonatomic, copy) NSString *objectId;

/////////////////////////

@property (nonatomic, strong) NSString * duration1;     // 歌曲的时长

@property (nonatomic, strong) NSMutableArray * timeForLyric;  // 时间对应的歌词


// 图片
@property (nonatomic, copy) NSString *image;


@property (nonatomic, strong) NSString * lyric;  // 歌词


// 歌词
@property (nonatomic, copy) NSString *lrc;

@end
