//
//  VideoView.m
//  ShowNews
//
//  Created by LK on 16/6/26.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import "VideoView.h"

@implementation VideoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initLayout];
    }
    return self;
}

- (void)initLayout
{
    self.myImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.myImageView.image = [UIImage imageNamed:@"111.jpg"];
    [self addSubview:self.myImageView];
    self.button = [UIButton buttonWithType:UIButtonTypeSystem];
    self.button.frame = CGRectMake(20, 514, self.frame.size.width - 40, 30);
    self.button.backgroundColor = [UIColor greenColor];
    [self.button setTitle:@"重新加载" forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.button];
}

- (void)buttonClick
{
    if (self.request) {
        self.request();
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
