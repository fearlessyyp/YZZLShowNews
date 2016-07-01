//
//  NewsFirstViewCell.m
//  ShowNews
//
//  Created by YYP on 16/6/28.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import "NewsFirstViewCell.h"
#import "UIImageView+WebCache.h"
#import "News.h"
#define kCount self.imageArr.count
#define kHeight self.frame.size.height


@implementation NewsFirstViewCell

// 添加子视图
- (void)addAllViews {
    // 创建scrollView对象
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
    // 设置属性
    self.scrollView.contentSize = CGSizeMake(kScreenSizeWidth, 0);
    
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    // 添加到父视图上
    [self.contentView addSubview:self.scrollView];
    // 将最后一张图片加到第一的位置
    [self addImageView:(int)(kCount - 1)];
    self.myImageView.tag = 300;
    self.myImageView.frame = CGRectMake(0, 0, kScreenSizeWidth, kHeight);
    // for循环添加imageView
    for (int i = 0; i < kCount; i++) {
        [self addImageView:i];
        self.myImageView.tag = 301 + i;
        self.myImageView.frame = CGRectMake(kScreenSizeWidth * (i + 1), 0, kScreenSizeWidth, kHeight);
    }
    // 将第一张放到最后的位置
    [self addImageView:0];
    self.myImageView.tag = kCount + 301;
    self.myImageView.frame = CGRectMake(kScreenSizeWidth * (kCount + 1), 0, kScreenSizeWidth, kHeight);
    // 设置初始偏移量
    self.scrollView.contentOffset = CGPointMake(kScreenSizeWidth, 0);
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, kHeight - 20, kScreenSizeWidth, 20)];
    backView.backgroundColor = NEWS_COLOR(0, 0, 0, 0.6);
    [self.contentView addSubview:backView];
    if (self.imageArr.count > 1) {
        // 创建pageControl对象
        self.pageControl = [[SMPageControl alloc] initWithFrame:CGRectMake(kScreenSizeWidth - kCount * 8, kHeight - 20, kCount * 8, 20)];
        // 设置小圆点个数
        self.pageControl.numberOfPages = kCount;
        self.pageControl.alignment = SMPageControlAlignmentRight;
        self.pageControl.indicatorMargin = 2.0f;
        self.pageControl.indicatorDiameter = 5.0f;
        self.pageControl.userInteractionEnabled = NO;
        [self.contentView addSubview:self.pageControl];
        self.scrollView.contentSize = CGSizeMake(kScreenSizeWidth * (kCount + 2), 0);
    }
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kScreenSizeWidth - CGRectGetWidth(self.pageControl.frame) - 20, 20)];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [backView addSubview:self.titleLabel];
}

// 创建imageView并添加到scrollView上
- (void)addImageView:(int)index {
    self.myImageView = [UIImageView new];
    self.myImageView.userInteractionEnabled = YES;
    [self.myImageView sd_setImageWithURL:[NSURL URLWithString:[self.imageArr[index] imgsrc]]];
    [self.scrollView addSubview:self.myImageView];
}

@end
