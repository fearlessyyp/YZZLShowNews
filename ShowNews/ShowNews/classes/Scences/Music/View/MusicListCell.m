//
//  MusicListCell.m
//  ShowNews
//
//  Created by ZZQ on 16/6/25.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import "MusicListCell.h"
#import "Music.h"

@interface MusicListCell ()
// 歌曲名
@property (weak, nonatomic) IBOutlet UILabel *musicLabel;

@property (weak, nonatomic) IBOutlet UILabel *singerLabel;
@property (weak, nonatomic) IBOutlet UILabel *specialLabel;


@property (weak, nonatomic) IBOutlet UIButton *collectButton;

@end

@implementation MusicListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

// 传值
- (void)bindModel:(Music *)model {
    self.musicLabel.text = model.musicName;
    self.singerLabel.text = model.singerName;
    self.specialLabel.text = model.specialName;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
