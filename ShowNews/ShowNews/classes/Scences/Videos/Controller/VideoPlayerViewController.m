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
#import <AFNetworking.h>
#import "NewsUrl.h"
@interface VideoPlayerViewController ()
// 声明播放视频的控件属性 [既可以播放音频,又可以播放视频]
@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, strong) AFHTTPSessionManager *session;
@property (nonatomic, strong) NSMutableArray *allDataArray;
@end

@implementation VideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonItemAction:)];
    self.navigationItem.leftBarButtonItem = backButtonItem;
   // VideoModel *model = [[VideoModel alloc] init];
    // Do any additional setup after loading the view from its nib.
    [self showUIWithVideoModel:self.model];
   }

// 懒加载数组
- (NSMutableArray *)allDataArray
{
    if (!_allDataArray) {
        _allDataArray = [NSMutableArray array];
    }
    return _allDataArray;
}

// 解析数据
- (void)readData
{
    __weak typeof (self)weakSelf = self;
    
    [self.session GET:NEWS_VIDEO_LIST_URL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"下载的进度");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 请求数据
        NSLog(@"请求成功");
        
        // 处理数据...
        NSArray *reusltArr = responseObject[@"V9LG4B3A0"];
        
        for (NSDictionary *dict in reusltArr) {
            VideoModel *videoModel = [[VideoModel alloc] init];
            [videoModel setValuesForKeysWithDictionary:dict];
            [weakSelf.allDataArray addObject:videoModel];
            
        }
       
        NSLog(@"=============%@", weakSelf.allDataArray);
        
        NSLog(@"请求成功%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败%@", error);
    }];
}

- (void)showUIWithVideoModel:(VideoModel*)model
{
 
    NSURL *sourceMovieURL = [NSURL URLWithString:model.mp4_url];
    NSLog(@"----++++++++++++++++++++++++++++++++----------------%@", model.mp4_url);
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

- (void)backBarButtonItemAction:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
