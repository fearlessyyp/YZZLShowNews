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
//屏幕的宽度
#define WindownWidth [[UIScreen mainScreen] bounds].size.width
//屏幕的高度
#define WindowHeight [[UIScreen mainScreen] bounds].size.height
@interface VideoViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *privateTableView;
@property (nonatomic, strong)NSMutableArray *newMarray;
@property (nonatomic, strong)NSString *string;
@property (nonatomic, strong)WXPlayerView *playView;
@property (nonatomic, strong)NSIndexPath *currentIndexPath;
@property (nonatomic, strong)VideoCell *currentCell;
@property (nonatomic, strong)VideoModel *currentModel;

@property (nonatomic, assign)BOOL isOnCell;
@property (nonatomic, assign)BOOL isOnWindow;
@property (assign, nonatomic)BOOL cellShouldShow;
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
//    CGFloat topHeight = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
//    self.navigationItem.title = self.Mymodel.name;
    self.isOnCell = NO;
    self.isOnWindow = NO;
    self.cellShouldShow = NO;
    self.privateTableView = [[UITableView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:(UITableViewStylePlain)];
    self.privateTableView.delegate = self;
    self.privateTableView.dataSource = self;
    [self handel];
    [self.view addSubview:self.privateTableView];
    //注册播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoDidFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    //屏幕旋转的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullScreenBtnClick:) name:WMPlayerFullScreenButtonClickedNotification object:nil];
    //切换清晰度的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ButtonActionWithflvScreen:) name:WXPlayerChangeFlvButtonClickNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ButtonActionWithHighScreen:) name:WXPlayerChangeHighButtonClickNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ButtonActionWithSuperScreen:) name:WXPlayerChangeSuperButtonClickNotification object:nil];
    //关闭通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeTheVideo:) name:WMPlayerClosedNotification object:nil];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)handel{
 
    __weak typeof(self) weakself = self;
    [[RequestHelper new] requestWithUrl:NEWS_VIDEO_LIST_URL WithSuccessBlock:^(id data) {
        for (NSDictionary *dict in data[@"V9LG4B3A0"]) {
            VideoModel *newModel = [[VideoModel alloc] init];
            [newModel setValuesForKeysWithDictionary:dict];
            [weakself.newMarray addObject:newModel];
            [weakself.privateTableView reloadData];
        }
    } failBlock:^(NSError *err) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.newMarray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VideoCell *cell = [VideoCell cellWithTableView:tableView];

    VideoModel *model = self.newMarray[indexPath.row];
    cell.model = model;
    [cell.playBtn addTarget:self action:@selector(startPlayVideo:) forControlEvents:UIControlEventTouchUpInside];
    cell.playBtn.tag = indexPath.row;
    cell.playBtn.indexPath = indexPath;
    
//    if (_playView&&_playView.superview) {
//        if (indexPath.row==_currentIndexPath.row) {
//            [cell.playBtn.superview sendSubviewToBack:cell.playBtn];
//        }else{
//            [cell.playBtn.superview bringSubviewToFront:cell.playBtn];
//        }
//        NSArray *indexpaths = [tableView indexPathsForVisibleRows];
//        if (![indexpaths containsObject:_currentIndexPath]&&_currentIndexPath!=nil) {//复用  
//            
//            if ([[UIApplication sharedApplication].keyWindow.subviews containsObject:_playView]) {
//                _playView.hidden = NO;
//            }else{
//                _playView.hidden = YES;
//                [cell.playBtn.superview bringSubviewToFront:cell.playBtn];
//            }
//        }else{
//            if ([cell.thumbImage.subviews containsObject:_playView]) {
//                [_playView play];
//                _playView.hidden = NO;
//            }
//            
//        }
//    }
//    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{


}

-(void)startPlayVideo:(UIButton *)sender{
    if (self.currentCell) {
        [self.currentCell.playBtn.superview bringSubviewToFront:self.currentCell.playBtn];
    }
    _currentIndexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSLog(@"currentIndexPath.row = %ld",_currentIndexPath.row);
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
        VideoModel *model = self.newMarray[sender.indexPath.row];
      //  self.currentModel = model;
//        NSString *requestUrl = [model.ID stringByReplacingOccurrencesOfString:@"==" withString:@""];
//        NSString *str = [NSString stringWithFormat:@"http://api.dotaly.com/lol/api/v1/getvideourl?iap=0&ident=408A6C12-3E61-42EE-A6DB-FB776FBB834E&jb=0&type=flv&vid=%@%%3D%%3D", requestUrl];

                self.playView = [[WXPlayerView alloc]initWithFrame:self.currentCell.backImageView.frame];
                [self.playView setURLString:model.mp4_url];
                [self.currentCell.contentView addSubview:self.playView];
                [self.currentCell.playBtn.superview sendSubviewToBack:self.currentCell.playBtn];
                [self.playView play];
                self.isOnCell = YES;
    
}


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
    
//        NSString *requestUrl = [self.currentModel.ID stringByReplacingOccurrencesOfString:@"==" withString:@""];
//        NSString *str = [NSString stringWithFormat:@"http://api.dotaly.com/lol/api/v1/getvideourl?iap=0&ident=408A6C12-3E61-42EE-A6DB-FB776FBB834E&jb=0&type=flv&vid=%@%%3D%%3D", requestUrl];
    VideoModel *model = [VideoModel new];
        __weak typeof(self) weakself = self;
        [[RequestHelper new] requestWithUrl:NEWS_VIDEO_LIST_URL WithSuccessBlock:^(id data) {
            [weakself.playView setURLString:model.mp4_url];
        } failBlock:^(NSError *err) {
        }];

    }
- (void)ButtonActionWithHighScreen: (NSNotification *)notice{
//    NSString *requestUrl = [self.currentModel.ID stringByReplacingOccurrencesOfString:@"==" withString:@""];
//    NSString *str = [NSString stringWithFormat:@"http://api.dotaly.com/lol/api/v1/getvideourl?iap=0&ident=408A6C12-3E61-42EE-A6DB-FB776FBB834E&jb=0&type=mp4&vid=%@%%3D%%3D", requestUrl];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
