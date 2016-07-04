//
//  PlayerManager.h
//  UIpdd_test___音乐播放器
//
//  Created by ZZQ on 16/5/28.
//  Copyright © 2016年 ZZQ. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Music;
@class MusicSearchController;
#warning 222222
// 协议 代理
//@protocol playerManagerDelegate <NSObject>



//@end

@interface PlayerManager : NSObject

/// 实例化代理属性
//@property (nonatomic,weak) id<playerManagerDelegate> delegate;

/// block传值///  当音乐被切换改变model传给Controller
@property (nonatomic, copy) void(^blocl)(Music *);

/// block传值当歌曲正在播放时被一直调用的代理方法
@property (nonatomic, copy) void(^time)(NSString *);


/// block传值///  当音乐被切换改变model传给Controller
@property (nonatomic, copy) void(^blocl1)(Music *);

/// block传值///  当音乐被切换改变model传给Controller
@property (nonatomic, copy) void(^bloclAPP)(Music *);
/// block传值当歌曲正在播放时被一直调用的代理方法
@property (nonatomic, copy) void(^time1)(NSString *);

+ (PlayerManager *)sharePlayer;

// 所有model信息
@property (nonatomic, strong) NSMutableArray *playList;

///  刷新UI
@property (nonatomic, copy) void(^block)();

@property (nonatomic,assign) NSInteger currentIndex;  // 当前的音乐下标
/// 当前URl
@property (nonatomic, copy) NSString *currentUrl;
///
//@property (nonatomic, copy) void(^time)();

// 获取歌曲列表的plist
- (void)getPlayList;

// 预播放
- (void)prepareMusic:(NSUInteger)index;

// 播放音乐
- (void)musicPlay;

// 音乐暂停
- (void)pause;

// 播放下一首歌曲
- (void)upMusic;

// 音乐时间跳转方法 参数为跳转到的秒数
- (void)musicSeekToTime:(float)time;

// 音乐音量的控制 0.0 ~ 1???
- (void)musicVolumn:(float)value;

// 播放下一首歌曲
- (void)nextMusic;

// 记录播放暂停
@property (nonatomic, assign) BOOL isStart;

// 记录是否收藏
//@property (nonatomic, assign) BOOL isCollect;

- (void)collectButtonClick:(UIButton *)sender;

// 搜索页的收藏BUTTON
@property (nonatomic, strong) UIButton *searchCollectButton;
// 详情页的收藏BUTTON
@property (nonatomic, strong) UIButton *detailCollectButton;

- (void)requestData:(MusicSearchController *)searchVC;
@end
