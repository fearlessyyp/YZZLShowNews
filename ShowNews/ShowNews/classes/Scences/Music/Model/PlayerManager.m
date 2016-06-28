//
//  PlayerManager.m
//  UIpdd_test___音乐播放器
//
//  Created by ZZQ on 16/5/28.
//  Copyright © 2016年 ZZQ. All rights reserved.
//

#import "PlayerManager.h"
//#import "Header.h"
#import "Music.h"
#import <AVFoundation/AVFoundation.h>
#import "MusicTimeFormatter.h"

@interface PlayerManager ()
@property (nonatomic,strong) AVPlayer *player; // 播放器属性
@property (nonatomic,strong) NSTimer *timer;  // 定时器

@property (nonatomic, strong) AVPlayerItem *playerItem;
@end


static PlayerManager *playerManager = nil;
@implementation PlayerManager

+ (PlayerManager *)sharePlayer {
    static dispatch_once_t oncrToken;
    dispatch_once(&oncrToken, ^{
        playerManager = [[PlayerManager alloc] init];
    });
    return playerManager;
}

#pragma make - Lazy loading Method  懒加载
- (NSMutableArray *)playList {
    if (_playList == nil) {
        _playList = [NSMutableArray array];
    }
    return _playList;
}

-(AVPlayer *)player{
    
    if (!_player) {
        _player = [[AVPlayer alloc]init];
    }
    return _player;
}

- (AVPlayerItem *)playerItem {
    if (!_playerItem) {
        _playerItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:@""]];
        [_playerItem addObserver:self
                                   forKeyPath:@"status"
                                      options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                                      context:nil];
    }
    return _playerItem;
}

#warning 111
// 初始化 内部对音乐播放状态添加观察者 当音乐播放完成时 调用指定的方法
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.currentIndex = -1;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didMusucFinished) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    return self;
}

// 这是当一首歌曲播放完成时调用的方法
- (void)didMusucFinished {
    [self pause];
    [self nextMusic];
    [self musicPlay];
}

#pragma mark 获取播放列表
- (void)getPlayList{
    //
    
    
    //    NSURL *url = [NSURL URLWithString:kPlaylistURL];
    //    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //    NSURLSession *session = [NSURLSession sharedSession];
    //    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    //        if (error) {
    //            NSLog(@"错误");
    //        }
    //        NSArray *array = [NSPropertyListSerialization propertyListWithData:data options:0 format:NULL error:nil];
    //        NSLog(@"%@",array);
    //
    //        for (NSDictionary *dict in array) {
    //            MusicInfo *musicInfo = [[MusicInfo alloc] init];
    //            [musicInfo setValuesForKeysWithDictionary:dict];
    //            [self.playList addObject:musicInfo];
    //        }
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            self.block();
    //        });
    //    }];
    //    [task resume];
}

// 通过外部点击的行数确定是在音乐列表中的哪一条数据 然后将歌曲的模型返回
-(Music *)getmusicInfoWithIndext:(NSUInteger)index{
    return self.playList[index];
}

// 预播放音乐 整个程序中调用次数最多的方法 很多地方需要调用这个方法 判断第二次点击的音乐是不是当前正在播放的音乐 然后内部直接调用单例中得到模型的方法 预播放需要实例化一个AVPlayerItem 也就是所谓的CD 实例化的时候使用模型中的MP3url的方法 然后调用AVPlayer中替换当前音乐的方法  也就是说外部的音乐状态改变是从这里边实现的  代理方法的安全判断与执行也从预播放中执行
- (void)prepareMusic:(NSUInteger)index {
    if ((self.playList.count <= 0)) {
        return;
    }
    Music *music2 = self.playList[index];
    if (self.blocl1) {
        self.blocl1(music2);
    }
    //    if (self.blocl) {
    //        self.blocl(music2);
    //    }
    
    
    if (self.currentIndex != index || music2.mp3Url != _currentUrl) {
        self.currentIndex = index;
        // 获取当前音乐信息
        Music *music = self.playList[index];
        if (self.playerItem) {
                        [self.playerItem removeObserver:self forKeyPath:@"status"];
//                    [self.player.currentItem removeObserver:self forKeyPath:@"status"];
                    }

        // 实例化一个PlayerItem作为Player的"CD"
        
        _playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:music.mp3Url]];
                  [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
        //        [self.player replaceCurrentItemWithPlayerItem:_playerItem];
        NSLog(@"MP3url%@", music.mp3Url);
        // 此赋值只判断是否跟点击之前是同一首歌
        _currentUrl = music.mp3Url;
     
        self.player = nil;
           // 替换当前的playerItem
                self.player = [[AVPlayer alloc] initWithPlayerItem:_playerItem];
        if (self.blocl) {
            self.blocl(music);
        }
                [self musicPlay];
        //        if (self.blocl1) {
        //            self.blocl1(music);
        //        }
        
        // 安全判断
        //        if ([self.delegate respondsToSelector:@selector(didMusicCutwithMusicInfo:)]) {
        //            [self.delegate didMusicCutWithMusicInfo:musicInfo];
        //        }
        //
        
        //        [_playerItem addObserver:self
        //                           forKeyPath:@"status"
        //                              options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
        //                              context:PlayViewStatusObservationContext];
        
    }
}

// 音乐播放
// 内部实例化一个计时器 调用监听的频率为0.1s一次
- (void)musicPlay{
    // 实例化一个计时器并且调用timeAction的频率为0.1
    [self.timer invalidate];
    self.timer = nil;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [self.player play];
    self.isStart = YES;
}

// 音乐暂停
- (void)pause{
    [self.timer invalidate];
    self.timer = nil;
    [self.player pause];
    self.isStart = NO;
}

// 播放上一首歌曲
- (void)upMusic{
    if (self.playList.count > 0) {
        [self prepareMusic:self.currentIndex - 1 < 0 ? self.playList.count - 1 : self.currentIndex - 1];
    }
}

// 播放下一首歌曲
- (void)nextMusic{
    if (self.playList.count > 0) {
        [self prepareMusic:self.currentIndex + 1 >= self.playList.count ? 0 : self.currentIndex + 1];
    }
}

// 计时器实现方法
- (void)timerAction{
    // 歌曲播放时向外部调用改变状态的方法
    
    // 获取当前播放的字典类型时间
    CGFloat currentTime = CMTimeGetSeconds(self.player.currentTime);
    // 歌曲播放时向外部调用改变状态的方法 并将格式化后的时间作为参数传出
    if (self.time) {
        self.time([MusicTimeFormatter getStringFormatBySeconds:currentTime]);
    }
    if (self.time1) {
        self.time1([MusicTimeFormatter getStringFormatBySeconds:currentTime]);
    }
}

// 音乐时间跳转方法 参数为跳转到的秒数
- (void)musicSeekToTime:(float)time {
    [self.player seekToTime: CMTimeMake(time, 1)];
}

// 音乐音量的控制 0.0 ~ 1???
- (void)musicVolumn:(float)value{
    self.player.volume = value;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    /* AVPlayerItem "status" property value observer. */
    
    AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
    //        MBProgressHUD *HUD = [[MBProgressHUD alloc] init];
    
    //        [self addSubview:HUD];
    
    
    switch (status)
    {
            /* Indicates that the status of the player is not yet known because
             it has not tried to load new media resources for playback */
        case AVPlayerStatusUnknown:
        {
            //                [HUD show:YES];
            if (!AVPlayerStatusUnknown) {
                //                    [HUD hide:YES];
                NSLog(@"--------------未知的");
            }
        }
            break;
            
        case AVPlayerStatusReadyToPlay:
        {
            //                [HUD hide:YES];
            /* Once the AVPlayerItem becomes ready to play, i.e.
             [playerItem status] == AVPlayerItemStatusReadyToPlay,
             its duration can be fetched from the item. */
            
            NSLog(@"============准备播放");
//            [self.player replaceCurrentItemWithPlayerItem:_playerItem];
            
            
        }
            break;
            
        case AVPlayerStatusFailed:
        {
            
            //                [HUD show:YES];
            NSLog(@"++++++++++ 失败了");
            //                self.player = [[AVPlayer alloc] initWithPlayerItem:_playerItem];
        }
            break;
            
    }
    
    //    else if (context == PlayViewCMTimeValue){
    //        NSArray *arr = change[@"new"];
    //        CMTimeRange range = [arr.lastObject CMTimeRangeValue];
    //        //当前缓冲的时间
    //        float time = CMTimeGetSeconds(range.start) +CMTimeGetSeconds(range.duration);
    //        float progressValue = time / CMTimeGetSeconds(self.currentItem.duration);
    //        self.bufferProgressView.progress = progressValue;
    //    }
}



@end
