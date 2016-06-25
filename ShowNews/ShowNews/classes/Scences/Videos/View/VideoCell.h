//
//  VideoCell.h
//  ShowNews
//
//  Created by LK on 16/6/24.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VideoModel;
@interface VideoCell : UITableViewCell
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

- (void)bindModel:(VideoModel *)model;


@end
