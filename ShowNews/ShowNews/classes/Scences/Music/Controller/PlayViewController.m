//
//  PlayViewController.m
//  UIpdd_test___音乐播放器
//
//  Created by ZZQ on 16/5/28.
//  Copyright © 2016年 ZZQ. All rights reserved.
//

#import "PlayViewController.h"
#import "PlayerConsole.h"
#import "PlayerManager.h"
#import <UIImageView+WebCache.h>
#import "Music.h"

@interface PlayViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstWith;

@property (nonatomic, strong) PlayerManager *playManager;
@property (nonatomic, strong) NSArray *lyricArr;

@property (weak, nonatomic) IBOutlet UIImageView *musicPic;

@property (weak, nonatomic) IBOutlet UITableView *musicLyric;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollerView;

@property (weak, nonatomic) IBOutlet PlayerConsole *playerConsole;

@property (nonatomic, strong) NSMutableArray *timeForLyric;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation PlayViewController

// 将播放页面视图做成单例 对操作状态进行保存

static PlayViewController *playVC = nil;
+ (PlayViewController *)sharePlayView{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        playVC = [[PlayViewController alloc] init];
    });
    return playVC;
}

//- (NSMutableArray *)timeForLyric {
//    if (!_timeForLyric) {
//        
//    }
//    return _timeForLyric;
//}

//- (instancetype)init {
//    if (self = [super init]) {
//        
//    }
//    return self;
//}

- (void)viewWillAppear:(BOOL)animated {
    [self.playManager prepareMusic:self.musicIndex];
    
    [self.musicLyric registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ce"];
}

- (void)loadLyricWithStr:(NSString *)str {
    NSArray *bigArray = [str componentsSeparatedByString:@"\n"];
    for (NSString *temStr in bigArray) {
        if (temStr.length > 14) {
            //在使用"]"拆解字符串后的结果("[00:00.000]","ABCD")
            NSArray *lyricAndTimeArr = [temStr componentsSeparatedByString:@"]"];
            //将时间拆解成想要的格式:"00:00"，以作为字典的key
            NSString *timeKey = [lyricAndTimeArr[0] substringWithRange:NSMakeRange(1, 5)];
            //以"00:00"，作为字典的key。"ABCD"(数组的最后一位)作为字典的value
            NSDictionary *lyricDic = @{timeKey: [lyricAndTimeArr lastObject]};
            // 时间歌词的数组添加到时间歌词字典
            [self.timeForLyric addObject:lyricDic];
        }
    }
}
// 更新约束
- (void)updateViewConstraints {
    [super updateViewConstraints];
    // 设置为两个屏幕宽
    self.viewWidth.constant = CGRectGetWidth([UIScreen mainScreen].bounds) *2;
    self.firstWith.constant = CGRectGetWidth([UIScreen mainScreen].bounds);
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.playManager = [PlayerManager sharePlayer];
    [self.musicPic.layer setMasksToBounds:YES];
    
    if ([PlayerManager sharePlayer].isStart == YES) {
        [self.playerConsole.playButtons setImage:[UIImage imageNamed:@"audionews_pause_button@2x"] forState:UIControlStateNormal];
        
    }else {
        [self.playerConsole.playButtons setImage:[UIImage imageNamed:@"audionews_play_button@2x"] forState:UIControlStateNormal];
        
    }
    
    // 专辑图片
    // 将改变约束的生命周期提前
    [self.musicPic.layer setCornerRadius:(([UIScreen mainScreen].bounds.size.width) - 100) / 2];
    self.scrollerView.showsHorizontalScrollIndicator = NO;
    
    // 当音乐被切换时调用的代理方法  外部需要拿到数据模型 进行改变
    __weak typeof(self)weakSelf = self;
    self.playManager.blocl1 = ^void (Music *musci) {
        
        
        NSLog(@"++++++++++++++%@", musci.picUrl);
        weakSelf.titleLabel.text = musci.musicName;
       
        
        //刷新TableView
        dispatch_async(dispatch_get_main_queue(), ^{
            // 将时间歌词添加到当前VC的数组中
            _timeForLyric = [NSMutableArray array];
            [weakSelf loadLyricWithStr:musci.lyricxxxx];
            weakSelf.lyricArr = [[NSArray alloc]initWithArray:weakSelf.timeForLyric];
            [weakSelf.musicPic sd_setImageWithURL:[NSURL URLWithString:musci.picUrl]];
            // 控制台
            [weakSelf.playerConsole prepareMusicInfo:musci];
           [weakSelf.musicLyric reloadData];
        });
        
    };
    
    //  当歌曲正在播放时被一直调用的方法
    self.playManager.time1 = ^void (NSString *str){
        [weakSelf.playerConsole playMusicWithFormatString:str];
        
        for (int i = 0; i < weakSelf.lyricArr.count; i++) {
            // 找到被变量的字典
            NSDictionary *dic = weakSelf.lyricArr[i];
            // [[dic allKeys]lastObject]找到字典中的字符串Key
            if ([str isEqualToString:[[dic allKeys]lastObject]])
            {
//                UITableViewCell *cell = [weakSelf.musicLyric cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
//                cell.textLabel.font = [UIFont systemFontOfSize:18];
            
                [weakSelf.musicLyric selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];

            }
        }
        weakSelf.musicPic.transform = CGAffineTransformRotate(weakSelf.musicPic.transform, M_PI/360);
        
    };
    
    self.musicLyric.delegate = self;
    self.musicLyric.dataSource = self;
    
    // 监听根据系统音量改变slder音量想
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChanged) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    
    
}
// 系统音量发生变化
- (void)volumeChanged{
    [self.playerConsole changeVoluem:[MPMusicPlayerController applicationMusicPlayer].volume];
}

//// 获取系统音量
-(float) getVolumeLevel
{
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    UISlider *volumeViewSlider= nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            volumeViewSlider = (UISlider*)view;
            break;
        }
    }
    return volumeViewSlider.value;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    NSLog(@"self.lyricArr.count");
    return self.lyricArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ce" forIndexPath:indexPath];
    
    NSDictionary *dict = self.lyricArr[indexPath.row];
//    NSLog(@"%lu", (unsigned long)self.lyricArr.count);
    cell.textLabel.text = dict.allValues[0];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textAlignment = 1;
    [cell.textLabel setNumberOfLines:0];
    
    cell.textLabel.font = [UIFont systemFontOfSize:13.0];
    
    // 设置文字高亮颜色
    cell.textLabel.highlightedTextColor = [UIColor colorWithRed:0.2 green:0.3 blue:0.9 alpha:1];
    
    
    // 设置被选取的cell
    UIView *view = [[UIView alloc]initWithFrame:cell.contentView.frame];
    view.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = view;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    return cell;
}

// 返回按钮
- (IBAction)backButtonClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)dealloc

{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    
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
