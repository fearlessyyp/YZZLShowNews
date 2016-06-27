//
//  VideoCell.m
//  ShowNews
//
//  Created by LK on 16/6/24.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import "VideoCell.h"
#import "VideoModel.h"
#import <UIImageView+WebCache.h>
#import "NSString+TimeFormatter.h"
@implementation VideoCell
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// 传值
- (void)bindModel:(VideoModel *)model
{
    self.titleLable.text = model.title;
    self.topicNameLable.text = model.topicName;
    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:model.cover]];
    [self.topicImgImageView sd_setImageWithURL:[NSURL URLWithString:model.topicImg]];
    self.timeLable.text = [NSString getStringWithTime:model.length];
}

@end
