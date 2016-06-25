//
//  Music.h
//  ShowNews
//
//  Created by ZZQ on 16/6/25.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Music : NSObject
// 歌词
@property (nonatomic, copy) NSString *lrc;
// 歌曲
@property (nonatomic, copy) NSString *musicName;
// 歌手
@property (nonatomic, copy) NSString *singerName;
// 专辑
@property (nonatomic, copy) NSString *specialName;
// ID
@property (nonatomic, copy) NSString *ID;
// 图片
@property (nonatomic, copy) NSString *image;


@end
