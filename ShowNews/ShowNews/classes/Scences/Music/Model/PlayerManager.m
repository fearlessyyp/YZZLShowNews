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
#import <MBProgressHUD.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVOSCloud/AVOSCloud.h>
#import "DataBaseHandle.h"

@interface PlayerManager ()
@property (nonatomic,strong) AVPlayer *player; // 播放器属性
@property (nonatomic,strong) NSTimer *timer;  // 定时器
@property (nonatomic, strong) Music *music;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong)MBProgressHUD *HUD; // 小菊花

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
    
    _music = self.playList[index];
    // 从数据库查询是否收藏
    [self selectFromMusicTable:nil];
    if (self.bloclAPP) {
        self.bloclAPP(_music);
    }
    
    [self configNowPlayingInfoCenter:_music];
    
    if (self.currentIndex != index || _music.mp3Url != _currentUrl) {
        self.currentIndex = index;
        // 获取当前音乐信息
        _music = self.playList[index];
        // 从数据库查询是否收藏
        [self selectFromMusicTable:nil];
        if (self.playerItem) {
            [self.playerItem removeObserver:self forKeyPath:@"status"];
            //                    [self.player.currentItem removeObserver:self forKeyPath:@"status"];
        }
        
        // 实例化一个PlayerItem作为Player的"CD"
        _playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:_music.mp3Url]];
        [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
        //        [self.player replaceCurrentItemWithPlayerItem:_playerItem];
        NSLog(@"MP3url%@", _music.mp3Url);
        // 此赋值只判断是否跟点击之前是同一首歌
        _currentUrl = _music.mp3Url;
        
        self.player = nil;
        // 替换当前的playerItem
        self.player = [[AVPlayer alloc] initWithPlayerItem:_playerItem];
        
        [self musicPlay];
        //        if (self.blocl1) {
        //            self.blocl1(music);
        //        }
    }
}


//设置锁屏状态，显示的歌曲信息
-(void)configNowPlayingInfoCenter:(Music *)music{
    if (NSClassFromString(@"MPNowPlayingInfoCenter")) {
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        //歌曲名称
        [dict setObject:music.musicName forKey:MPMediaItemPropertyTitle];
        
        //演唱者
        [dict setObject:music.singerName forKey:MPMediaItemPropertyArtist];
        
        //专辑名
        [dict setObject:music.specialName forKey:MPMediaItemPropertyAlbumTitle];
        
        //专辑缩略图
        //        UIImage *image = [UIImage imageNamed:[info objectForKey:@"image"]];
        //        MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:image];
        //        [dict setObject:artwork forKey:MPMediaItemPropertyArtwork];
        
        //音乐剩余时长
        [dict setObject:[NSNumber numberWithDouble:[music.duration floatValue] / 1000] forKey:MPMediaItemPropertyPlaybackDuration];
        
        //音乐当前播放时间 在计时器中修改
        [dict setObject:[NSNumber numberWithDouble:0.0] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
        
        //设置锁屏状态下屏幕显示播放音乐信息
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
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
int i = 0;
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
    switch (status)
    {
            /* Indicates that the status of the player is not yet known because
             it has not tried to load new media resources for playback */
        case AVPlayerStatusUnknown:
        {
            if (!AVPlayerStatusUnknown) {
                NSLog(@"--------------未知的");
            }
        }
            break;
            
        case AVPlayerStatusReadyToPlay:
        {
            NSLog(@"============准备播放");
        }
            break;
            
        case AVPlayerStatusFailed:
        {
            NSLog(@"++++++++++ 失败了");
            _HUD = [MBProgressHUD showHUDAddedTo:[self getCurrentVC].view animated:YES];
            _HUD.mode = MBProgressHUDModeText;
            _HUD.labelColor = [UIColor greenColor];
            NSString *str = [NSString stringWithFormat:@"<%@>因版权问题无法播放",_music.musicName];
            _HUD.labelText = str;
            _HUD.minShowTime = 2;
            _HUD.opacity = 0.1;
            _HUD.color = [UIColor clearColor];
            _HUD.yOffset = i += 30;
            if (i > [UIScreen mainScreen].bounds.size.height / 2 - 30) {
                i = - [UIScreen mainScreen].bounds.size.height / 2;
            }
            //            _HUD.dimBackground = YES;
            [_HUD hide:YES];
            _HUD.userInteractionEnabled = NO;
            [self pause];
            if (self.currentIndex != self.playList.count -1) {
                [self nextMusic];
                [self musicPlay];
            }
            
        }
            break;
    }
}



//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

// 收藏按钮点击
- (void)collectButtonClick:(UIButton *)sender {
    _music = _playList[_currentIndex];
    if (_music.IsCollect) {
        // 删除逻辑
        NSString *cql = @"delete from Music where objectId = ?";
        NSArray *pvalues =  @[_music.objectId];
        [AVQuery doCloudQueryInBackgroundWithCQL:cql pvalues:pvalues callback:^(AVCloudQueryResult *result, NSError *error) {
            // 如果 error 为空，说明删除成功
            if (!error) {
                // 删除成功
                [sender setImage:[UIImage imageNamed:@"newscollect"] forState:UIControlStateNormal];
                _music.IsCollect = NO;
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[self getCurrentVC].view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"取消收藏成功";
                hud.margin = 10.f;
                hud.yOffset = 0.f;
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:1];
            } else {
                NSLog(@"~~~~~~error = %@", error);
            }
        }];
        
    } else {
        // 存储逻辑
        AVObject *object = [[DataBaseHandle sharedDataBaseHandle] musicTOAVObject:_music];
        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                // 从表中获取数据->objectID
                [self selectFromMusicTable:sender];
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[self getCurrentVC].view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"收藏成功";
                hud.margin = 10.f;
                hud.yOffset = 0.f;
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:1];
            } else {
                NSLog(@"!!!error = %@", error);
            }
        }];
    }
    
    
}

- (void)selectFromMusicTable:(UIButton *)sender {
    NSString *cql = [NSString stringWithFormat:@"select * from %@ where username = ? and ID = ?", @"Music"];
    NSArray *pvalues =  @[@1, self.music.ID];
        [AVQuery doCloudQueryInBackgroundWithCQL:cql pvalues:pvalues callback:^(AVCloudQueryResult *result, NSError *error) {
            if (!error) {
                // 操作成功
#warning 延迟不及时操作
                
                if (result.results.count > 0) {
                    AVObject *obj = result.results[0];
                    _music.objectId = obj.objectId;
//                    [_detailCollectButton setImage:[UIImage imageNamed:@"newscollected"] forState:UIControlStateNormal];
//                    [_searchCollectButton setImage:[UIImage imageNamed:@"newscollected"] forState:UIControlStateNormal];
                    _music.IsCollect = YES;
                    NSLog(@"IsCollect = %d", _music.IsCollect);
                }
            } else {
                NSLog(@"%@", error);
            }
            if (self.blocl) {
                self.blocl(_music);
            }
            if (self.blocl1) {
                self.blocl1(_music);
            }

            NSLog(@"result ====== %@", result);
        }];
}

@end
