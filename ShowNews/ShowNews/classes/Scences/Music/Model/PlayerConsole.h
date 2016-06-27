//
//  PlayerConsole.h
//  UIpdd_test___音乐播放器
//
//  Created by ZZQ on 16/5/28.
//  Copyright © 2016年 ZZQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>  
@class Music;
@interface PlayerConsole : UIView

/*
 当每次准备播放一首歌时的方法
 参数为音乐模型类
 */
- (void)prepareMusicInfo:(Music *)music;


/*
 当音乐已经播放时所调用的方法
 参数是格式化的时间字符串
 */
- (void)playMusicWithFormatString:(NSString *)string;
@end

