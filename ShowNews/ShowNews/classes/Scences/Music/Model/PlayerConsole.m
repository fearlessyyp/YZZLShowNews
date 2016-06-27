//
//  PlayerConsole.m
//  UIpdd_test___音乐播放器
//
//  Created by ZZQ on 16/5/28.
//  Copyright © 2016年 ZZQ. All rights reserved.
//

#import "PlayerConsole.h"
#import "PlayerManager.h"
#import "Music.h"
#import "MusicTimeFormatter.h"


@interface PlayerConsole ()
// 时间条
@property (nonatomic, weak) IBOutlet UISlider *timeSlide;

@property (nonatomic,weak) IBOutlet UISlider *volumeSlide; // 声音条

@property (nonatomic,weak) IBOutlet UILabel *currentTimes; // 当前时间label

@property (nonatomic,weak) IBOutlet UILabel *totalTimes;  // 总时间label

@property (nonatomic,weak) IBOutlet UIButton *upButtons;  // 上一首button

@property (nonatomic,weak) IBOutlet UIButton *nextButtons;  // 下一首button

@property (nonatomic,weak) IBOutlet UIButton *playButtons;  // 播放&暂停按钮

@end

@implementation PlayerConsole

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)prepareMusicInfo:(Music *)music{
    self.currentTimes.text = @"00:00";
    
    // 获取音乐模型中的秒数
    NSInteger seconds = [music.duration intValue] / 1000;
    // 使用音乐时间工具类 将秒数转换为格式化后的字符串
    self.totalTimes.text = [MusicTimeFormatter getStringFormatBySeconds:seconds];
    self.timeSlide.maximumValue = seconds;
    
}
// 当音乐已经播放时所调用的方法
// 参数是格式化的时间字符串
- (void)playMusicWithFormatString:(NSString *)string{
    self.timeSlide.value = [MusicTimeFormatter getSecondsFormatByString:string];
    self.currentTimes.text = string;
    
}


//   播放按钮
- (IBAction)PlayButtonClicked:(UIButton *)sender{
    if ([sender.titleLabel.text isEqualToString:@"播放"]) {
        [[PlayerManager sharePlayer] musicPlay];
        [sender setTitle:@"暂停" forState:UIControlStateNormal];
    }else {
        [[PlayerManager sharePlayer] pause];
        sender.titleLabel.text = @"播放";
        [sender setTitle:@"播放" forState:UIControlStateNormal];
    }
}

// 时间
- (IBAction)TimeSliderValueChanged:(UISlider *)sender{
    [[PlayerManager sharePlayer] musicSeekToTime:sender.value];
}

// 音量
- (IBAction)VolumnSliderValueChanged:(UISlider *)sender{
    MPMusicPlayerController *musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
    [[PlayerManager sharePlayer] musicVolumn:sender.value];
    musicPlayer.volume = sender.value;
}

// 上一首按钮的触发时间
- (IBAction)UpButtonClicked:(UIButton *)sender{
    [[PlayerManager sharePlayer] upMusic];
}

// 下一首按钮的触发事件
- (IBAction)NextButtonClicked:(UIButton *)sender{
    [[PlayerManager sharePlayer] nextMusic];
}
@end
