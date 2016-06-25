//
//  VideoCell.m
//  ShowNews
//
//  Created by LK on 16/6/24.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import "VideoCell.h"
#import "VideoModel.h"
@implementation VideoCell
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)bindModel:(VideoModel *)model
{
    self.titleLable.text = model.title;
    self.topicNameLable.text = model.topicName;
    
}

@end
