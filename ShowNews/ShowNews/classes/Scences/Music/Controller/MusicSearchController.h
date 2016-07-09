//
//  MusicSearchController.h
//  ShowNews
//
//  Created by ZZQ on 16/6/24.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h> 
#import "Singleton.h"
@interface MusicSearchController : BaseViewController

singleton_interface(MusicSearchController);

/// 大数组
@property (nonatomic, strong) NSMutableArray *allArr;
/// 搜索结果列表
@property (weak, nonatomic) IBOutlet UITableView *listResultTableView;
/// 收藏
@property (weak, nonatomic) IBOutlet UIButton *collect;
/// 播放
@property (weak, nonatomic) IBOutlet UIButton *palyButton;
@end
