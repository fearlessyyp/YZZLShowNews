//
//  NewTableViewCell.m
//  WXAVPlayer
//
//  Created by lanou3g on 16/6/17.
//  Copyright © 2016年 wxerters. All rights reserved.
//

#import "VideoCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface VideoCell ()

@property (nonatomic, assign)BOOL isPlaying;
@end

@implementation VideoCell

+ (instancetype)cellWithTableView: (UITableView *)tableView{
    static NSString *identifier = @"tg";
    VideoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"VideoCell" owner:nil options:nil]firstObject];
    }
    return cell;
}

- (void)setModel:(VideoModel *)model{
   
    [self.topicImgImageView sd_setImageWithURL:[NSURL URLWithString:model.topicImg]];
    self.titleLable.text = model.title;
    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:model.cover]];
        self.topicNameLable.text = model.topicName;
    
}

- (IBAction)shareButtonAction:(id)sender {
    
    
    
    
    
}





- (void)addMovie: (UIView *)view{
    [self.backImageView addSubview:view];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
