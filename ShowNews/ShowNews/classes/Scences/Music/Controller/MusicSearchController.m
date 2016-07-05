//
//  MusicSearchController.m
//  ShowNews
//
//  Created by ZZQ on 16/6/24.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import "MusicSearchController.h"
#import <AFNetworking.h>
#import "NewsUrl.h"
#import <AFNetworkActivityIndicatorManager.h>
#import "Music.h"
#import "MusicListCell.h"
#import "PlayViewController.h"
#import "PlayerManager.h"
#import "GDataXMLNode.h"
#import "UIImageView+WebCache.h"
#import <AVFoundation/AVFoundation.h>
#import <MJRefresh.h>
#import <AVOSCloud/AVOSCloud.h>
#import <MBProgressHUD.h>
#import "DataBaseHandle.h"

@interface MusicSearchController ()<UITableViewDelegate, UITableViewDataSource>
/// 搜索栏
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;



/// 播放控制器
@property (weak, nonatomic) IBOutlet UIView *bofangView;

/// 用于网络请求的session对象
@property (nonatomic, strong) AFHTTPSessionManager *session;


/// 距左的约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftTransform;
/// button 的间距

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *speaceButton1;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *speaceButton2;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *speaceButton;

/// 图片
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;

/// 歌曲名
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

/// 歌手名
@property (weak, nonatomic) IBOutlet UILabel *singerLabel;
/// 上一首
@property (weak, nonatomic) IBOutlet UIButton *lastButton;

/// 下一首
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
/// 播放
@property (weak, nonatomic) IBOutlet UIButton *palyButton;

/// 收藏
@property (weak, nonatomic) IBOutlet UIButton *collect;

@property (nonatomic, strong) PlayerManager *playManager;

@property (nonatomic, assign) NSInteger page;
// 用于收藏的音乐
@property (nonatomic, strong) Music *music;

@end

@implementation MusicSearchController


- (IBAction)touchView:(id)sender {
     [self.view endEditing:YES];  
}

#warning 111
// 收藏按钮
- (IBAction)shareButton:(UIButton *)sender {
    
}

//- (void)viewWillAppear:(BOOL)animated {
//    
//}


- (void)viewDidAppear:(BOOL)animated {
    // button间的约束宽度
    self.speaceButton.constant = self.speaceButton1.constant = self.speaceButton2.constant = (self.bofangView.frame.size.width - 67 - 130 - 4) / 3;
    
    // 关联系统播放台
    NSLog(@"viewDidAppear!!!");
    [super viewDidAppear:animated];
    //Once the view has loaded then we can register to begin recieving controls and we can become the first responder
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    [self becomeFirstResponder];
}

// 关联系统播放台
- (void)viewWillDisappear:(BOOL)animated {
    
    NSLog(@"viewWillDisappear!!!");
    
    [super viewWillDisappear:animated];
    
    //End recieving events
    
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    
    [self resignFirstResponder];

    
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}


- (void)updateViewConstraints {
    [super updateViewConstraints];
    self.leftTransform.constant = [UIScreen mainScreen].bounds.size.width *0.12 + 8;
}



// 懒加载
- (NSMutableArray *)allArr {
    if (!_allArr) {
        _allArr = [NSMutableArray array];
    }
    return _allArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 观察isStart的状态
    [[PlayerManager sharePlayer] addObserver:self forKeyPath:@"isStart" options:NSKeyValueObservingOptionNew context:nil];
    
    [self.navigationController setNavigationBarHidden:YES];
    // 单例 初始化session对象
    self.session = [AFHTTPSessionManager manager];
    
    // 注册cell
    [self.listResultTableView registerNib:[UINib nibWithNibName:@"MusicListCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    // 当音乐被切换时调用的代理方法  外部需要拿到数据模型 进行改变
    [self blockChangeMP3];
    
    //让app支持接受远程控制事件
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    
//    // 上拉刷新下拉刷新
//    self.listResultTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [self.allArr removeAllObjects];
//        self.page = 1;
//        [self requestData];
//    }];
    
//    self.listResultTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        
//        self.page++;
//        NSLog(@"==========================%ld", (long)self.page);
//        [self requestData];
//        
//    }];
    
    [PlayerManager sharePlayer].searchCollectButton = _collect;
    
    // 第一次进入时候显示收藏列表
    [[PlayerManager sharePlayer] requestData:self];
    
    [self.searchTextField addTarget:self action:@selector(ifValueIsNil) forControlEvents:UIControlEventEditingDidEnd];
    
    [self.searchTextField addTarget:self action:@selector(ifValueIsNilIsEQ:) forControlEvents:UIControlEventEditingChanged];
    
}

- (void)ifValueIsNilIsEQ:(UITextField *)sender {
    if ([sender.text isEqualToString:@""]) {
        [sender resignFirstResponder];
    }
    
}

- (void)ifValueIsNil {
    if (self.searchTextField.text.length <= 0) {
        [[PlayerManager sharePlayer] requestData:self];
       
    }
}

//// 隐藏上拉下拉刷新
//- (void)endRefresh {
//    [self.listResultTableView.mj_header endRefreshing];
//    [self.listResultTableView.mj_footer endRefreshing];
//}


#pragma mark ------  block

- (void)blockChangeMP3{
    // 当音乐被切换时调用的代理方法  外部需要拿到数据模型 进行改变
    
    self.playManager = [PlayerManager sharePlayer];
    
    __weak typeof(self)weakSelf = self;
    self.playManager.blocl = ^void (Music *musci) {

        weakSelf.titleLabel.text = musci.musicName;
        weakSelf.singerLabel.text = musci.singerName;
      
        [weakSelf.photoImage sd_setImageWithURL:[NSURL URLWithString:musci.picUrl]];
        if (musci.IsCollect == YES) {
            [weakSelf.collect setImage:[UIImage imageNamed:@"action_love_selected@2x"] forState:UIControlStateNormal];
        }else {
            [weakSelf.collect setImage:[UIImage imageNamed:@"action_love@2x"] forState:UIControlStateNormal];
        }
//        //刷新TableView
//        dispatch_async(dispatch_get_main_queue(), ^{
//          
//        });
        
    };
}

- (IBAction)searchButtonAction:(UIButton *)sender {
    [self.allArr removeAllObjects];
    self.page = 1;
    [self requestData];
    
}


// 请求数据
- (void)requestData{
    //     判断当前是wifi状态、3g、4g还是网络不可用状态
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        /**
         32          AFNetworkReachabilityStatusUnknown          = -1,   未知网络
         33          AFNetworkReachabilityStatusNotReachable     = 0,    没有网络连接
         34          AFNetworkReachabilityStatusReachableViaWWAN = 1,    3g,4g
         35          AFNetworkReachabilityStatusReachableViaWiFi = 2,    WIFI状态
         36          */
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"当前网络处于未知状态");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"当前没有网络连接");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"当前处于WIFI状态");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"当前处于移动网络状态，请您注意您的流量");
                break;
            default:
                break;
                
        }
    }];
    
    
    // 设置请求返回支持的文件类型
    self.session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"application/x-json",@"text/html", @"application/x-javascript", nil];
    
    // 转圈圈的菊花默认是关闭的，需要手动打开，在网络慢的情况下请求数据时，手机左上角就会出现转圈圈的菊花
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    NSString *str = [NSString stringWithFormat:NEWS_MUSIC_SEARCH_URL231,(long)self.page,self.searchTextField.text];
    NSString *urlStr = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    __weak typeof(self) weakSelf = self;

    [self.session GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"下载进度");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 打印请求到的数据
        //                 responseObject[@"data"];
        NSDictionary *resultDict = responseObject;
        NSArray *array = resultDict[@"data"][@"song"][@"list"];
        if (array.count > 0) {
            for (NSDictionary *dic in array) {
                NSArray *arr = [dic[@"f"] componentsSeparatedByString:@"|"];
                if (arr.count < 23) {
                    continue;
                }
                // 初始化model 并赋值
                Music *music = [[Music alloc] init];
                
                //                const char *arr1 = [arr[1] UTF8String];
                NSString *name = arr[1];
                if ([name containsString:@"&amp;#"]) {
                    music.musicName = [self editStr:name];
                } else {
                    music.musicName = arr[1];
                }
                
                music.lrc = arr[0];
                NSString *singer = arr[3];
                if ([singer containsString:@"&amp;#"]) {
                    music.singerName = [self editStr:singer];
                } else {
                    music.singerName = arr[3];
                }
                NSString *special = arr[5];
                if ([special containsString:@"&amp;#"]) {
                    music.specialName = [self editStr:special];
                } else {
                    music.specialName = arr[5];
                }
                music.duration = [arr[7] stringByAppendingString:@"000"];
                
                music.ID = arr[20];
                music.image = arr[22];
                
                // 歌曲图片网址
                music.picUrl = [NSString stringWithFormat:@"http://imgcache.qq.com/music/photo/mid_album_90/%@/%@/%@.jpg",[music.image substringWithRange:NSMakeRange(music.image.length-2, 1)], [music.image substringFromIndex:music.image.length-1], music.image];
                //                NSLog(@"-------------------------%@", music.picUrl);
                
                // 歌曲网址
                music.mp3Url = [NSString stringWithFormat:NEWS_MUSIC_PLAY_URL, music.ID];
                // 歌词网址
                music.lyric = [NSString stringWithFormat:@"http://music.qq.com/miniportal/static/lyric/%@/%@.xml", [music.lrc substringFromIndex:music.lrc.length - 2], music.lrc];
                
                 // 用指针修改music里的lrcXXXXXXX
                [self requestLrc:music];
                [weakSelf.allArr addObject:music];
               
                
            }
            // 隐藏下拉上拉刷新
//            [self endRefresh];
            dispatch_async(dispatch_get_main_queue(), ^{
            [PlayerManager sharePlayer].playList = weakSelf.allArr;
            [weakSelf.listResultTableView reloadData];
            });
        }
        
        // 解析数据代码写在这里
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 隐藏下拉上拉刷新
//        [self.listResultTableView.mj_footer endRefreshingWithNoMoreData];
//        [self.listResultTableView.mj_header endRefreshing];
    }];
}



- (NSString *)editStr:(NSString *)name {
    name = [name substringFromIndex:6];
    name = [name stringByReplacingOccurrencesOfString:@";" withString:@""];
    //    NSLog(@"++++++++++++%@", name);
    NSArray *nameArr = [name componentsSeparatedByString:@"&amp#"];
    NSMutableString *resultStr = [NSMutableString string];
    for (NSString *str in nameArr) {
        
        NSString *hexString = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x", str.intValue]];
        //        NSLog(@"=========%@", str);
        NSString *str1 = [MusicSearchController replaceUnicode:[NSString stringWithFormat:@"\\U%@", hexString]];
        [resultStr appendString:str1];
    }
    return resultStr;
    
}

#pragma mark - 转换韩文
+ (NSString *)replaceUnicode:(NSString *)unicodeStr {
    
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    // NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"%u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2]stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [ NSPropertyListSerialization  propertyListFromData:tempData mutabilityOption:NSPropertyListImmutable format:NULL errorDescription:NULL];
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}

// 请求歌词 
- (void)requestLrc:(Music *)music {
    __weak typeof(self) weakSelf = self;
    NSURLSession *sesson = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:music.lyric];
    NSURLSessionTask *task = [sesson dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error == nil) {
            //            NSLog(@"%@", data);
            // M解析 (创建解析文档)
            GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:data options:0 error:nil];
            
            
            // 4. 获取根节点
            NSString *str2 = document.rootElement.stringValue;
//            dispatch_async(dispatch_get_main_queue(), ^{
                music.lyricxxxx = str2;
//                [weakSelf.allArr addObject:music];
//                [PlayerManager sharePlayer].playList = weakSelf.allArr;
//                [weakSelf.listResultTableView reloadData];

//            });
            
        }
        NSLog(@"haha");
    }];
    [task resume];
}


#pragma mark - Table view data source
//  设置分区个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
// 设置每个分区的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allArr.count;
}

// 返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MusicListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    Music *music = self.allArr[indexPath.row];
    [cell bindModel:music];
    
    return cell;
}

//- (void)bindDict:(Music *)music {
//    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
//
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     [PlayViewController sharePlayView];
    [[PlayerManager sharePlayer] prepareMusic:indexPath.row];
    Music *music = self.allArr[indexPath.row];
    [self bindSmallMusicController:music];
    [self.view endEditing:YES];
}

- (void)configNowPlayingInfoCenter {
    
    
    if (NSClassFromString(@"MPNowPlayingInfoCenter")) {
        
        [PlayerManager sharePlayer].bloclAPP = ^(Music *music) {
            NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
            
            [dict setObject:music.musicName forKey:MPMediaItemPropertyTitle];
            
            [dict setObject:music.singerName forKey:MPMediaItemPropertyArtist];
            
            [dict setObject:music.specialName forKey:MPMediaItemPropertyAlbumTitle];
            
            NSLog(@"hahahahahahahhahaha==== %@", music.musicName);
            //            dispatch_async(dispatch_get_main_queue(), ^{
            //                UIImageView *musicImage = [[UIImageView alloc] init];
            //                [musicImage sd_setImageWithURL:[NSURL URLWithString:music.picUrl]];
            //
            //                MPMediaItemArtwork * mArt = [[MPMediaItemArtwork alloc] initWithImage:musicImage.image];
            
            //                [dict setObject:mArt forKey:MPMediaItemPropertyArtwork];
            //            });
            
            
            [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = nil;
            
            [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
            
            
        };
        
        
        
    }
    
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- 播放器

- (void)bindSmallMusicController:(Music *)music {
    if ([self.titleLabel.text isEqualToString:music.musicName] && [self.singerLabel.text isEqualToString:music.singerName]) {
        return;
    }
    self.titleLabel.text = music.musicName;
    self.singerLabel.text = music.singerName;
   
    [self.photoImage sd_setImageWithURL:[NSURL URLWithString:music.image]];
    NSLog(@"z%@",music.picUrl);
}

// 点击播放按钮
- (IBAction)PlayButtonClick:(UIButton *)sender {
    
    if ([PlayerManager sharePlayer].isStart == YES) {
        [sender setImage:[UIImage imageNamed:@"audionews_play_button@2x"] forState:UIControlStateNormal];
        [[PlayerManager sharePlayer] pause];
        [PlayerManager sharePlayer].isStart = NO;
    }else {
        [sender setImage:[UIImage imageNamed:@"audionews_pause_button@2x"] forState:UIControlStateNormal];
        [[PlayerManager sharePlayer] musicPlay];
        [PlayerManager sharePlayer].isStart = YES;
    }
}

// 点击CELL 跳转
- (IBAction)imageClick:(UITapGestureRecognizer *)sender {
    PlayViewController *playVC = [PlayViewController sharePlayView];
#warning  点击搜索按钮后currentIndex 值 特别大
    if ([PlayerManager sharePlayer].currentIndex < 100000) {
        playVC.musicIndex = [PlayerManager sharePlayer].currentIndex;
    }
    
    [self.navigationController pushViewController:playVC animated:YES];
    
//    self.view.layer.borderWidth
//    self.view.layer.cornerRadius

    
}

// 上一首
- (IBAction)UpButtonClick:(id)sender {
    [[PlayerManager sharePlayer] upMusic];
}

// 下一首
- (IBAction)nextButtonClick:(id)sender {
    [[PlayerManager sharePlayer] nextMusic];
}

// KVO 属性变化时
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
     BOOL isStrat = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
    if (isStrat) {
            [self.palyButton setImage:[UIImage imageNamed:@"audionews_pause_button@2x"] forState:UIControlStateNormal];
            [[PlayViewController sharePlayView].playButton setImage:[UIImage imageNamed:@"audionews_pause_button@2x"] forState:UIControlStateNormal];
        }else {
            [self.palyButton setImage:[UIImage imageNamed:@"audionews_play_button@2x"] forState:UIControlStateNormal];
            [[PlayViewController sharePlayView].playButton setImage:[UIImage imageNamed:@"audionews_play_button@2x"] forState:UIControlStateNormal];
    }
    
    
}

- (void)dealloc {
    
    [[PlayerManager sharePlayer] removeObserver:self forKeyPath:@"isStart" context:nil];
//
}


+ (UIBackgroundTaskIdentifier)backgroundPlayerID:(UIBackgroundTaskIdentifier)backTaskId
{
    // 1. 设置并激活音频会话类别
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    // 2. 允许应用程序接收远程控制
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    // 3. 设置后台任务ID
    UIBackgroundTaskIdentifier newTaskId = UIBackgroundTaskInvalid;
    newTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    if (newTaskId != UIBackgroundTaskInvalid && backTaskId != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:backTaskId];
    }
    return newTaskId;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
//当点击键盘上return按钮的时候调用
{
    //代理记录了当前正在工作的UITextField的实例，因此你点击哪个UITextField对象，形参就是哪个UITextField对象
    [self searchButtonAction:nil];
    [textField resignFirstResponder];//键盘回收代码
    return YES;
}

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    if ([@"\n" isEqualToString:text] == YES)
//    {
//        [textView resignFirstResponder];
//        
//        
//        return NO;
//    }
//    
//    return YES;
//}




/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

// 点击收藏按钮
- (IBAction)collectButtonClick:(UIButton *)sender {
    
    [[PlayerManager sharePlayer] collectButtonClick:sender];

}



@end
