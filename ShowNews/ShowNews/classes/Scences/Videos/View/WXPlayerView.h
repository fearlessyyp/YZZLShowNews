//
//  WXPlayerView.h
//  WXPlayer
//
//  Created by lanou3g on 16/6/14.
//  Copyright © 2016年 wxerters. All rights reserved.
//
/** 全屏按钮被点击的通知 */
#define WMPlayerFullScreenButtonClickedNotification @"WMPlayerFullScreenButtonClickedNotification"
/** 关闭播放器的通知 */
#define WMPlayerClosedNotification @"WMPlayerClosedNotification"
/** 播放完成的通知 */
#define WMPlayerFinishedPlayNotification @"WMPlayerFinishedPlayNotification"
/** 清晰度按钮被点击的通知 */
#define WXPlayerChangeFlvButtonClickNotification @"WXPlayerChangeFlvButtonClickNotification"
#define WXPlayerChangeHighButtonClickNotification @"WXPlayerChangeHighButtonClickNotification"
#define WXPlayerChangeSuperButtonClickNotification @"WXPlayerChangeSuperButtonClickNotification"
/** 单击播放器view的通知 */
#define WMPlayerSingleTapNotification @"WMPlayerSingleTapNotification"
/** 双击播放器view的通知 */
#define WMPlayerDoubleTapNotification @"WMPlayerDoubleTapNotification"

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Masonry.h>
@import MediaPlayer;

/** 播放器的几种状态 */
typedef NS_ENUM(NSInteger, WXPlayerState) {
    /** 播放失败 */
    WXPlayerStateFailed,
    /** 缓冲中 */
    WXPlayerStateBuffering,
    /** 播放中 */
    WXPlayerStatePlaying,
    /** 停止播放 */
    WXPlayerStateStopped,
    /** 暂停播放 */
    WXPlayerStatePause
};
@interface WXPlayerView : UIView
/** 播放器player */
@property (nonatomic, strong)AVPlayer *player;
/** playerLayer,可修改frame */
@property (nonatomic, strong)AVPlayerLayer *playerLayer;
/** 播放器的状态 */
@property (nonatomic, assign)WXPlayerState state;
/** 底部操作工具栏 */
@property (nonatomic, strong)UIView *bottomView;
/** 定时器 */
@property (nonatomic, strong)NSTimer *durationTimer;
@property (nonatomic, strong)NSTimer *autoDismissTimer;
/** BOOL值判断当前的状态 */
@property (nonatomic, assign)BOOL isFullScreen;
/** 控制全屏按钮 */
@property (nonatomic, strong)UIButton *fullScreenBtn;
/** 播放暂停按钮 */
@property (nonatomic, strong)UIButton *playOrPauseBtn;
/** 关闭按钮 */
@property (nonatomic, strong)UIButton *closeBtn;
/** 当前播放的Item */
@property (nonatomic, strong)AVPlayerItem *currentItem;
/** 设置播放的URLString,可以是本地路径也可以是http网络路径 */
@property (nonatomic, copy)NSString *URLString;
/** 切换清晰度的view */
//@property (nonatomic, strong)UIView *changeView;
//@property (nonatomic, strong)UIButton *changeButton;
@property (nonatomic, strong)UIButton *flvButton;
@property (nonatomic, strong)UIButton *highDefinitionButton;
@property (nonatomic, strong)UIButton *superDefinitionButton;

@property (nonatomic, assign) BOOL isKKKKK;


/** 播放 */
- (void)play;
/** 暂停 */
- (void)pause;
/** 跳到time处播放 */
- (void)seekToTimeToPlay: (double)time;
/** 获取正在播放的点 */
- (double)currentTime;

- (void)colseTheVideo:(UIButton *)sender;

//- (void)updateLayerFrame: (CGRect)frame;
//+ (instancetype)shareWXPlayerView: (CGRect)frame;
//@property (nonatomic, strong)NSString *url;

@end
