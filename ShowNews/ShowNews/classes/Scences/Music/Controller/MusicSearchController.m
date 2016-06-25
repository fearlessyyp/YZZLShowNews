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
@interface MusicSearchController ()<UITableViewDelegate, UITableViewDataSource>
/// 搜索栏
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

/// 搜索结果列表
@property (weak, nonatomic) IBOutlet UITableView *listResultTableView;

/// 用于网络请求的session对象
@property (nonatomic, strong) AFHTTPSessionManager *session;

/// 大数组
@property (nonatomic, strong) NSMutableArray *allArr;
@end

@implementation MusicSearchController

// 懒加载
- (NSMutableArray *)allArr {
    if (!_allArr) {
        _allArr = [NSMutableArray array];
    }
    return _allArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
    // 单例 初始化session对象
    self.session = [AFHTTPSessionManager manager];
    
    // 注册cell
    [self.listResultTableView registerNib:[UINib nibWithNibName:@"MusicListCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    

    
}

- (IBAction)searchButtonAction:(UIButton *)sender {
    [self.allArr removeAllObjects];
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
    
    NSString *str = [NSString stringWithFormat:NEWS_MUSIC_SEARCH_URL231,self.searchTextField.text ];
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
                NSLog(@"!!!!!!!!!!!!!!%@", arr);
                // 初始化model 并赋值
                Music *music = [[Music alloc] init];
//                const char *arr1 = [arr[1] UTF8String];
                music.musicName = arr[1];
                music.lrc = arr[0];
                music.singerName = arr[3];
                music.specialName = arr[5];
//                music.duration = [array[7] stringByAppendingString:@"000"];
                music.ID = arr[20];
                music.image = arr[22];

                // 歌曲图片网址
                music.picUrl = [NSString stringWithFormat:@"http://imgcache.qq.com/music/photo/mid_album_90/%@/%@/%@.jpg",[music.image substringWithRange:NSMakeRange(music.image.length-2, 1)], [music.image substringFromIndex:music.image.length-1], music.image];
                
                // 歌曲网址
                music.mp3Url = [NSString stringWithFormat:NEWS_MUSIC_PLAY_URL, music.ID];
                // 歌词网址
                music.lyric = [NSString stringWithFormat:@"http://music.qq.com/miniportal/static/lyric/%@/%@.xml", [music.lrc substringFromIndex:music.lrc.length - 2], music.lrc];
                
//                [self requestLrc:music.lrc];
                
                [weakSelf.allArr addObject:music];
            }
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [PlayerManager sharePlayer].playList = weakSelf.allArr;
            [weakSelf.listResultTableView reloadData];
        });
        
        // 解析数据代码写在这里
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败, error = %@", error);
    }];
}

//- (NSString *)requestLrc:(NSString *)str {
//    __weak typeof(self) weakSelf = self;
//    [self.session GET:str parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//        NSLog(@"下载进度");
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//        NSLog(@"%@", responseObject);
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [weakSelf.listResultTableView reloadData];
//        });
//        
//        // 解析数据代码写在这里
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"请求失败, error = %@", error);
//    }];
//}




#pragma mark - Table view data source
//  设置分区个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PlayViewController *playVC = [PlayViewController sharePlayView];
    
    playVC.musicIndex = indexPath.row;
    
    [self.navigationController pushViewController:playVC animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
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
