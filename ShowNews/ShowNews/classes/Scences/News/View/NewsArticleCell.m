//
//  NewsArticleCell.m
//  ShowNews
//
//  Created by ZZQ on 16/6/24.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import "NewsArticleCell.h"
#import <UIImageView+WebCache.h>

@interface NewsArticleCell ()
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *titlelabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;


@end

@implementation NewsArticleCell

- (void)bindData:(News *)news {
    [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:news.imgsrc]];
    self.titlelabel.text = news.title;
    self.sourceLabel.text = news.source;
}

@end
