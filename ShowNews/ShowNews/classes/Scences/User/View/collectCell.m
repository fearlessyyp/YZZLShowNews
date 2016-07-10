//
//  collectCell.m
//  ShowNews
//
//  Created by ZZQ on 16/6/29.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import "collectCell.h"

@implementation collectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)tap:(id)sender {
    self.block(1);
}

- (IBAction)videoCollectTap:(id)sender {
    self.block(2);
}

- (IBAction)musicCollectTap:(UITapGestureRecognizer *)sender {
    self.block(3);
}



@end
