//
//  NewTableViewCell.h
//  WXAVPlayer
//
//  Created by lanou3g on 16/6/17.
//  Copyright © 2016年 wxerters. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "VideoModel.h"
#import "UIButton+CellButton.h"
@class VideoCell;

@interface VideoCell : UITableViewCell
@property (nonatomic, strong)VideoModel *model;

@property (weak, nonatomic) IBOutlet UIButton *playBtn;

// / 视频图片
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
// / 标题lable
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
// / 时间lable
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
// / 视频发布者头像
@property (weak, nonatomic) IBOutlet UIImageView *topicImgImageView;
// / 视频发布者
@property (weak, nonatomic) IBOutlet UILabel *topicNameLable;

- (void)addMovie: (UIView *)view;
+ (instancetype)cellWithTableView: (UITableView *)tableView;
@end
