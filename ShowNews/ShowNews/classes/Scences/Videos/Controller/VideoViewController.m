//
//  NewViewController.m
//  WXPlayer
//
//  Created by lanou3g on 16/6/15.
//  Copyright © 2016年 wxerters. All rights reserved.
//
#import "VideoViewController.h"
#import "VideoModel.h"
#import "VideoCell.h"
#import "UIButton+CellButton.h"
#import "WXPlayerView.h"
#import "RequestHelper.h"
#import "NewsUrl.h"
#import <MJRefresh.h>
#import <MJRefreshAutoStateFooter.h>
#import <MJRefreshFooter.h>
#import <Masonry.h>
#import <AFNetworking.h>
#import <MBProgressHUD.h>
#import "LoginViewController.h"
#import <UMSocial.h>
#import "DataBaseHandle.h"
//屏幕的宽度
#define WindownWidth [[UIScreen mainScreen] bounds].size.width
//屏幕的高度
#define WindowHeight [[UIScreen mainScreen] bounds].size.height


@interface VideoViewController ()<UITableViewDelegate, UITableViewDataSource,UMSocialUIDelegate>

@property (nonatomic, strong)NSString *string;
@property (nonatomic, strong)WXPlayerView *playView;
@property (nonatomic, strong)NSIndexPath *currentIndexPath;
@property (nonatomic, strong)VideoCell *currentCell;
@property (nonatomic, strong)VideoModel *currentModel;
// 判断视频是否在cell上
@property (nonatomic, assign)BOOL isOnCell;
// 判断视频是否在window上
@property (nonatomic, assign)BOOL isOnWindow;
// 判断是否展示cell
@property (assign, nonatomic)BOOL cellShouldShow;
@property (assign, nonatomic) NSInteger page; //!< 数据页数.表示下次请求第几页的数据.
// 进行网络监测判断的bool值
@property (nonatomic, assign) BOOL isOpen;
@end

@implementation VideoViewController



- (BOOL)prefersStatusBarHidden{
    if (_playView) {
        if (_playView.isFullScreen) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [self initLayouts];
    
    
}


// 结束更新 隐藏刷新
- (void)endRefresh
{
    [self.privateTableView.mj_header endRefreshing];
    [self.privateTableView.mj_footer endRefreshing];
}

// 更新数据
- (void)updateData
{
    __weak typeof (self)weakSelf = self;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:NES_VIDEO_DOWN_URL((long)self.page) parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"下载的进度");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *resultArr = responseObject[@"V9LG4B3A0"];
        for (NSDictionary *dict in resultArr) {
            VideoModel *model = [[VideoModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            [weakSelf.newMarray addObject:model];
        }
        [self endRefresh];
        // 主线程刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.privateTableView reloadData];
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self endRefresh];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"您的网络不给力!";
        [hud hide: YES afterDelay: 2];
    }];
    
}

- (void)initLayouts
{
    self.isOnCell = NO;
    self.isOnWindow = NO;
    self.cellShouldShow = NO;
    self.privateTableView = [[UITableView alloc] initWithFrame: CGRectMake(0, 0, kScreenSizeWidth, kScreenSizeHeight - kNavigationAndStatusHeight + 44) style:(UITableViewStylePlain)];
    self.privateTableView.delegate = self;
    self.privateTableView.dataSource = self;
    // 下拉刷新
    if (!self.iscollect) {
        _privateTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self.newMarray removeAllObjects];
            self.page = 0;
            [self updateData];
        }];
        // 上拉刷新
        _privateTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            self.page += 10;
            [self updateData];
        }];
    }
    
    
    [self handel];
    [self.view addSubview:self.privateTableView];
    //注册播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoDidFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    //屏幕旋转的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullScreenBtnClick:) name:WMPlayerFullScreenButtonClickedNotification object:nil];
    //关闭通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeTheVideo:) name:WMPlayerClosedNotification object:nil];
    [super viewDidLoad];
}


// 解析数据LeanCloudSocial
- (void)handel{
    if (self.iscollect == YES) {
        return;
    }
    __weak typeof(self) weakself = self;
    [[RequestHelper new] requestWithUrl:NEWS_VIDEO_LIST_URL WithSuccessBlock:^(id data) {
        if (data != nil) {
            for (NSDictionary *dict in data[@"V9LG4B3A0"]) {
                VideoModel *newModel = [[VideoModel alloc] init];
                [newModel setValuesForKeysWithDictionary:dict];
                [weakself.newMarray addObject:newModel];
                [weakself.privateTableView reloadData];
            }
        }
        
    } failBlock:^(NSError *err) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"您的网络不给力!";
        [hud hide: YES afterDelay: 2];
        
    }];
}

// 设置分区个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.newMarray.count;
}

// 返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VideoCell *cell = [VideoCell cellWithTableView:tableView];
    if (self.newMarray.count >= 1) {
        VideoModel *model = self.newMarray[indexPath.row];
        NSLog(@"+++++++++=====%@", model);
        cell.model = model;
        [cell.playBtn addTarget:self action:@selector(startPlayVideo:) forControlEvents:UIControlEventTouchUpInside];
        cell.playBtn.tag = indexPath.row;
        cell.playBtn.indexPath = indexPath;
        
        // 友盟分享的block实现
        cell.Block = ^void(VideoModel *model)
        {
            model = self.newMarray[indexPath.row];
            
            [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:model.cover];
            
            //分享内嵌文字
            NSString *shareText = [NSString stringWithFormat:@"%@[视频地址:%@]", model.title, model.mp4_url];
            
            //分享内嵌图片
            //UIImage *shareImage = ;
            
            //分享样式数组
            NSArray *shareArr = [NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToQQ,UMShareToQzone,UMShareToRenren,UMShareToDouban,UMShareToEmail,UMShareToSms, nil];
            
            [UMSocialSnsService presentSnsIconSheetView:self appKey:UmengAppkey shareText:shareText shareImage:[UIImage imageNamed:@"2.jpg"] shareToSnsNames:shareArr delegate:self];
            
        };
        
        // 跳转到登录页面
        cell.LoginVCBlock = ^void() {
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            [self.navigationController pushViewController:loginVC animated:YES];
        };
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)startPlayVideo:(UIButton *)sender{
    if (self.currentCell) {
        [self.currentCell.playBtn.superview bringSubviewToFront:self.currentCell.playBtn];
    }
    _currentIndexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSLog(@"currentIndexPath.row = %ld",(long)_currentIndexPath.row);
    if ([UIDevice currentDevice].systemVersion.floatValue>=8||[UIDevice currentDevice].systemVersion.floatValue<7) {
        self.currentCell = (VideoCell *)sender.superview.superview;
    }else{//ios7系统 UITableViewCell上多了一个层级UITableViewCellScrollView
        self.currentCell = (VideoCell *)sender.superview.superview.subviews;
        
    }
    //    isSmallScreen = NO;
    if (_isOnWindow) {
        [self releaseWXPlayer];
        _isOnWindow = NO;
        
    }
    if (_playView) {
        [self releaseWXPlayer];
        
    }
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    if (![DataBaseHandle sharedDataBaseHandle].isWifi) {
        // 接下来会判断当前是WiFi状态还是3g状态,网络不可用状态
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusUnknown:
                    [self setHUD:@"请检查网络"];
//                    NSLog(@"当前网络处于未知状态");
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                    [self setHUD:@"请检查网络"];
//                    NSLog(@"当前网络处于未链接状态");
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    [self setHUD:@"当前处于3g/4g状态"];
//                    NSLog(@"手机流量网络");
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi: {
                    NSLog(@"wifi状态");
                    VideoModel *model = self.newMarray[sender.indexPath.row];
                    
                    self.playView = [[WXPlayerView alloc]initWithFrame:self.currentCell.backImageView.frame];
                    [self.playView setURLString:model.mp4_url];
                    [self.currentCell.contentView addSubview:self.playView];
                    [self.currentCell.playBtn.superview sendSubviewToBack:self.currentCell.playBtn];
                    [self.playView play];
                    self.isOnCell = YES;
                    break;
                }
                    
                default:
                    break;
            }
        }];
        
    } else {
        NSLog(@"+++++++++++");
        VideoModel *model = self.newMarray[sender.indexPath.row];
        self.playView = [[WXPlayerView alloc]initWithFrame:self.currentCell.backImageView.frame];
        [self.playView setURLString:model.mp4_url];
        [self.currentCell.contentView addSubview:self.playView];
        [self.currentCell.playBtn.superview sendSubviewToBack:self.currentCell.playBtn];
        [self.playView play];
        self.isOnCell = YES;
        
    }
    
    
    
}

// 视图消失的时候关闭视频
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.playView colseTheVideo:nil];

//    [self.playView.player play];
//    [self.playView pause];
}

// 设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 280;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.privateTableView) {
        VideoCell *cell = [self.privateTableView cellForRowAtIndexPath:self.currentIndexPath];
        CGRect currentCellRect = [self.privateTableView convertRect:cell.frame toView:self.view];
        if (currentCellRect.origin.y < -cell.frame.size.height + 64 || currentCellRect.origin.y > self.view.bounds.size.height) {
            [self putToWindow];
            self.cellShouldShow = YES;
        }
        else{
            if (self.cellShouldShow) {
                [self backToCell];
            }
        }
    }
}

// 将视频在window显示
- (void)putToWindow{
    if (!self.isOnWindow || self.playView.isFullScreen) {
        [self.playView removeFromSuperview];
        [UIView animateWithDuration:0.5 animations:^{
            self.playView.transform = CGAffineTransformIdentity;
            self.playView.frame = CGRectMake(WindownWidth/2,WindowHeight-(WindowHeight/2)*0.75, WindownWidth/2, (WindowHeight/2)*0.75);
            [self.playView.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.playView).with.offset(0);
                make.right.equalTo(self.playView).with.offset(0);
                make.height.mas_equalTo(40);
                make.bottom.equalTo(self.playView).with.offset(0);
                [[UIApplication sharedApplication].keyWindow addSubview:self.playView];
            }];
        } completion:^(BOOL finished) {
            self.isOnWindow = YES;
            self.isOnCell = NO;
            self.playView.isFullScreen = NO;
            self.playView.fullScreenBtn.selected = NO;
        }];
    }
}

// 将视频在cell上显示
- (void)backToCell{
    if (!self.isOnCell) {
        VideoCell *cell = [self.privateTableView cellForRowAtIndexPath:self.currentIndexPath];
        [self.playView removeFromSuperview];
        [UIView animateWithDuration:0.5f animations:^{
            self.playView.transform = CGAffineTransformIdentity;
            self.playView.frame = cell.backImageView.frame;
            [cell.contentView addSubview:self.playView];
            [self.playView.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.playView).with.offset(0);
                make.right.equalTo(self.playView).with.offset(5);
                make.height.mas_equalTo(40);
                make.bottom.equalTo(self.playView).with.offset(0);
            }];
        } completion:^(BOOL finished) {
            self.playView.isFullScreen = NO;
            self.isOnCell = YES;
            self.isOnWindow = NO;
            self.playView.fullScreenBtn.selected = NO;
        }];
    }
}

#pragma mark - 通知方法
- (void)videoDidFinished: (NSNotification *)notice{
    VideoCell *cell = [self.privateTableView cellForRowAtIndexPath:self.currentIndexPath];
    [cell.playBtn.superview bringSubviewToFront:_currentCell.playBtn];
    [self releaseWXPlayer];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)closeTheVideo: (NSNotification *)notice{
    VideoCell *cell = [self.privateTableView cellForRowAtIndexPath:self.currentIndexPath];
    [cell.playBtn.superview bringSubviewToFront:cell.playBtn];
    [self releaseWXPlayer];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)ButtonActionWithflvScreen: (NSNotification *)notice{
    
    VideoModel *model = [VideoModel new];
    __weak typeof(self) weakself = self;
    [[RequestHelper new] requestWithUrl:NEWS_VIDEO_LIST_URL WithSuccessBlock:^(id data) {
        [weakself.playView setURLString:model.mp4_url];
    } failBlock:^(NSError *err) {
    }];
    
}
- (void)ButtonActionWithHighScreen: (NSNotification *)notice{
    
    VideoModel *model = [VideoModel new];
    
    __weak typeof(self) weakself = self;
    [[RequestHelper new] requestWithUrl:NEWS_VIDEO_LIST_URL WithSuccessBlock:^(id data) {
        [weakself.playView setURLString:model.mp4_url];
    } failBlock:^(NSError *err) {
    }];
    
}

- (void)ButtonActionWithSuperScreen: (NSNotification *)notice{
    //    NSString *requestUrl = [self.currentModel.ID stringByReplacingOccurrencesOfString:@"==" withString:@""];
    //    NSString *str = [NSString stringWithFormat:@"http://api.dotaly.com/lol/api/v1/getvideourl?iap=0&ident=408A6C12-3E61-42EE-A6DB-FB776FBB834E&jb=0&type=hd2&vid=%@%%3D%%3D", requestUrl];
    VideoModel *model = [VideoModel new];
    
    __weak typeof(self) weakself = self;
    [[RequestHelper new] requestWithUrl:NEWS_VIDEO_LIST_URL WithSuccessBlock:^(id data) {
        [weakself.playView setURLString:model.mp4_url];
    } failBlock:^(NSError *err) {
    }];
    
}

- (NSMutableArray *)newMarray{
    if (!_newMarray) {
        _newMarray = [NSMutableArray array];
    }
    return _newMarray;
}

- (void)dealloc{
    if (self.playView) {
        self.isOnWindow = NO;
        self.isOnCell = NO;
        self.cellShouldShow = NO;
        [self releaseWXPlayer];
    }
}

#pragma mark - 切换清晰度
/**
 *  释放WMPlayer
 */
-(void)releaseWXPlayer{
    [_playView.player.currentItem cancelPendingSeeks];
    [_playView.player.currentItem.asset cancelLoading];
    [_playView pause];
    
    //移除观察者
    [_playView.currentItem removeObserver:_playView forKeyPath:@"status"];
    [_playView.currentItem removeObserver:_playView forKeyPath:@"loadedTimeRanges"];
    
    [_playView removeFromSuperview];
    [_playView.playerLayer removeFromSuperlayer];
    [_playView.player replaceCurrentItemWithPlayerItem:nil];
    _playView.player = nil;
    _playView.currentItem = nil;
    //释放定时器，否侧不会调用WMPlayer中的dealloc方法
    [_playView.autoDismissTimer invalidate];
    _playView.autoDismissTimer = nil;
    [_playView.durationTimer invalidate];
    _playView.durationTimer = nil;
    
    _playView.playOrPauseBtn = nil;
    _playView.playerLayer = nil;
    _playView = nil;
}

// 视图将要出现时
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];

    if (self.iscollect) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backItemAction:)];
        self.title = @"视频收藏";
    }
    [self.privateTableView reloadData];
#warning 判断当前时间与上次刷新时间,如果超过半个小时,自动刷新
//    [NSTimer scheduledTimerWithTimeInterval:1800 target:self selector:@selector(timeAction:) userInfo:nil repeats:YES];
}

- (void)backItemAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)timeAction:(NSTimer *)time
{
    [self.privateTableView.mj_header beginRefreshing];
}

- (void)onDeviceOrientationChange{
    if (self.playView == nil || self.playView.superview == nil) {
        return;
    }
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortraitUpsideDown:
            break;
            
        case UIInterfaceOrientationPortrait:
            if (self.playView.isFullScreen) {
                if (_isOnWindow) {
                    [self putToWindow];
                }else{
                    [self backToCell];
                }
            }
            break;
        case UIInterfaceOrientationLandscapeLeft:
            if (self.playView.isFullScreen == NO) {
                self.playView.isFullScreen = YES;
                [self setNeedsStatusBarAppearanceUpdate];
                [self toFullScreenWithInterfaceOrientation:interfaceOrientation];
            }
            break;
        case UIInterfaceOrientationLandscapeRight:
            if (self.playView.isFullScreen == NO) {
                self.playView.isFullScreen = YES;
                [self setNeedsStatusBarAppearanceUpdate];
                [self toFullScreenWithInterfaceOrientation:interfaceOrientation];
            }
            break;
            
        default:
            break;
    }
}


-(void)fullScreenBtnClick:(NSNotification *)notice{
    UIButton *fullScreenBtn = (UIButton *)[notice object];
    if (fullScreenBtn.isSelected) {
        self.playView.isFullScreen = YES;
        [self setNeedsStatusBarAppearanceUpdate];
        [self toFullScreenWithInterfaceOrientation:UIInterfaceOrientationLandscapeRight];
    }else{
        if (self.playView.isFullScreen) {
            if (_isOnWindow) {
                [self putToWindow];
            }else{
                [self backToCell];
            }
        }
    }
}

// 全屏播放视频
-(void)toFullScreenWithInterfaceOrientation:(UIInterfaceOrientation )interfaceOrientation{
    [self.playView removeFromSuperview];
    self.playView.transform = CGAffineTransformIdentity;
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        self.playView.transform = CGAffineTransformMakeRotation(- M_PI_2);
    }else if (interfaceOrientation == UIInterfaceOrientationLandscapeRight){
        self.playView.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    self.playView.frame = CGRectMake(0, 0, WindownWidth, WindowHeight);
    self.playView.playerLayer.frame = CGRectMake(0, 0, WindownWidth, WindowHeight);
    [self.playView.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(WindownWidth - 40);
        make.width.mas_equalTo(WindowHeight);
    }];
    //    [self.playView.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
    //        make.right.equalTo(self.playView).width.offset((-WindowHeight / 2));
    //        make.height.mas_equalTo(30);
    //        make.width.mas_equalTo(30);
    //        make.top.equalTo(self.playView).with.offset(5);
    //    }];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.playView];
    self.isOnCell = NO;
    self.playView.fullScreenBtn.selected = YES;
    [self.playView bringSubviewToFront:self.playView.bottomView];
}

- (void)setHUD:(NSString *)string {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = string;
    [hud hide: YES afterDelay: 2];

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
