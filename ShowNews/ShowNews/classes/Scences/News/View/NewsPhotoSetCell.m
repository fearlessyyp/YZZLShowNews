//
//  NewsPhotoSetCell.m
//  ShowNews
//
//  Created by ZZQ on 16/6/24.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import "NewsPhotoSetCell.h"
#import "UIImageView+WebCache.h"

@interface NewsPhotoSetCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UIImageView *centerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageVIew;
@end

@implementation NewsPhotoSetCell
- (void)bindData:(News *)news {
    self.titleLabel.text = news.title;
    [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:news.imgsrc]];
    if (news.imgextra.count >= 2) {
        [self.centerImageView sd_setImageWithURL:news.imgextra[0][@"imgsrc"]];
        [self.rightImageVIew sd_setImageWithURL:news.imgextra[1][@"imgsrc"]];
    }
}
@end
