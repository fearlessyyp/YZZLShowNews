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
#import <UIImageView+WebCache.h>
@interface MusicSearchController ()<UITableViewDelegate, UITableViewDataSource>
/// 搜索栏
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

/// 搜索结果列表
@property (weak, nonatomic) IBOutlet UITableView *listResultTableView;


@property (weak, nonatomic) IBOutlet UIView *bofangView;


/// 用于网络请求的session对象
@property (nonatomic, strong) AFHTTPSessionManager *session;

/// 大数组
@property (nonatomic, strong) NSMutableArray *allArr;
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

/// 音量
@property (weak, nonatomic) IBOutlet UISlider *volume;


@property (nonatomic, strong) PlayerManager *playManager;

@end

@implementation MusicSearchController

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"llllllllllllllllll%f", self.bofangView.frame.size.width);
    self.speaceButton.constant = self.speaceButton1.constant = self.speaceButton2.constant = (self.bofangView.frame.size.width - 67 - 120 - 4) / 3;
    NSLog(@"iiiiiiii%f",self.speaceButton.constant);
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    self.leftTransform.constant = [UIScreen mainScreen].bounds.size.width *0.12 + 8;
    NSLog(@"llllllllllllllllll%f", self.bofangView.frame.size.width);
//    self.speaceButton.constant = self.speaceButton1.constant = self.speaceButton2.constant =
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
    
    [self.navigationController setNavigationBarHidden:YES];
    // 单例 初始化session对象
    self.session = [AFHTTPSessionManager manager];
    
    // 注册cell
    [self.listResultTableView registerNib:[UINib nibWithNibName:@"MusicListCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
#pragma mark ------  block
    // 当音乐被切换时调用的代理方法  外部需要拿到数据模型 进行改变
    
    self.playManager = [PlayerManager sharePlayer];
    
    __weak typeof(self)weakSelf = self;
    self.playManager.blocl = ^void (Music *musci) {
        
        
        NSLog(@"++++++++++++++%@", musci.picUrl);
        weakSelf.titleLabel.text = musci.musicName;
        weakSelf.singerLabel.text = musci.singerName;
        
        
        //刷新TableView
        dispatch_async(dispatch_get_main_queue(), ^{
            // 将时间歌词添加到当前VC的数组中
//            _timeForLyric = [NSMutableArray array];
//            [weakSelf loadLyricWithStr:musci.lyricxxxx];
//            weakSelf.lyricArr = [[NSArray alloc]initWithArray:weakSelf.timeForLyric];
            [weakSelf.photoImage sd_setImageWithURL:[NSURL URLWithString:musci.picUrl]];
            // 控制台
//            [weakSelf prepareMusicInfo:musci];
//            [weakSelf.musicLyric reloadData];
        });
        
    };

    
    
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
                //                NSLog(@"!!!!!!!!!!!!!!%@", arr);
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
                
                
                [self requestLrc:music];
                
                
                
            }
            
        }
        
        // 解析数据代码写在这里
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败, error = %@", error);
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


- (NSString *)requestLrc:(Music *)music {
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
                dispatch_async(dispatch_get_main_queue(), ^{
                    music.lyricxxxx = str2;
                    [weakSelf.allArr addObject:music];
                    [PlayerManager sharePlayer].playList = weakSelf.allArr;
                    [weakSelf.listResultTableView reloadData];
                    NSLog(@"===============%@---------,%@",str2, music.lyric);
                });

            
            
            
            
        }
        
        
        //        // 3. 设置DO//        return str2;
        //        // 5. 遍历获取相对应的子节点
        //        for (GDataXMLElement *studentElement in rootElement.children) {
        //            Student *stu = [[Student alloc] init];
        //
        //            // 遍历子节点的子节点
        //            for (GDataXMLElement *stuElement in studentElement.children) {
        //                //            NSLog(@"stuElement = %@", stuElement);
        //
        //                // 根据标签给student对象赋值
        //                //stuElement.name 相当于 标签的名字
        //                //stuElement.stringValue 相当于 标签的值
        //                // KVC
        //                [stu setValue:stuElement.stringValue forKey:stuElement.name];
        //            }
        //            [self.dataArray addObject:stu];
        //        }
        //
        //        // 打印校验
        //        for (Student *stu in self.dataArray) {
        //            NSLog(@"name = %@, gender = %@, age = %ld, hobby = %@",stu.name, stu.gender, stu.age, stu.hobby);
        //        }
        
        
    }];
    [task resume];
    return nil;
}




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
//    PlayViewController *playVC = [PlayViewController sharePlayView];
//    
//    playVC.musicIndex = indexPath.row;
//    
//    [self.navigationController pushViewController:playVC animated:YES];
    [[PlayerManager sharePlayer] prepareMusic:indexPath.row];
//    [[PlayerManager sharePlayer] musicPlay];
    Music *music = self.allArr[indexPath.row];
    [self bindSmallMusicController:music];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- 播放器

- (void)bindSmallMusicController:(Music *)music {
    self.titleLabel.text = music.musicName;
    self.singerLabel.text = music.singerName;
    [self.photoImage sd_setImageWithURL:[NSURL URLWithString:music.image]];
    NSLog(@"z%@",music.picUrl);
}



- (IBAction)PlayButtonClick:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"播放"]) {
        [[PlayerManager sharePlayer] musicPlay];
        [sender setTitle:@"暂停" forState:UIControlStateNormal];
    }else {
        [[PlayerManager sharePlayer] pause];
        sender.titleLabel.text = @"播放";
        [sender setTitle:@"播放" forState:UIControlStateNormal];
    }
}


- (IBAction)VolumnSliderValueChange:(UISlider *)sender {
    MPMusicPlayerController *musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
    
    musicPlayer.volume = sender.value;
    [[PlayerManager sharePlayer] musicVolumn:sender.value];
}





- (IBAction)UpButtonClick:(id)sender {
    [[PlayerManager sharePlayer] upMusic];
}


- (IBAction)nextButtonClick:(id)sender {
    [[PlayerManager sharePlayer] nextMusic];
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
