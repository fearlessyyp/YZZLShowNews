//
//  VideoPlayerViewController.m
//  ShowNews
//
//  Created by LK on 16/6/25.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import "VideoPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "VideoModel.h"
@interface VideoPlayerViewController ()
// 声明播放视频的控件属性 [既可以播放音频,又可以播放视频]
@property (nonatomic, strong) AVPlayer *player;

@end

@implementation VideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    VideoModel *model = [[VideoModel alloc] init];
    NSURL *sourceMovieURL = [NSURL URLWithString:model.mp4_url];
   
    // 设置播放的项目
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:sourceMovieURL];
    
    // 初始化player对象
    self.player = [[AVPlayer alloc] initWithPlayerItem:item];
    
    // 设置播放页面
    
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:_player];
    
    // 设置播放的页面的大小
    layer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300);
    
    // 设置背景颜色
    layer.backgroundColor = [UIColor cyanColor].CGColor;
    
    // 设置播放窗口和当前视图之间的比例显示内容
    layer.videoGravity = AVLayerVideoGravityResizeAspect;
    
    // 添加播放视图到self.view上
    [self.view.layer addSublayer:layer];
    
    // 设置播放进度的默认值
   
    // 设置播放的默认音量值
    self.player.volume = 1.0f;
    

    [self.player play];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
