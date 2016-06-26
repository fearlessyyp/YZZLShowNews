//
//  BigScrollView.m
//  ShowNews
//
//  Created by YYP on 16/6/26.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import "BigScrollView.h"

@interface BigScrollView ()<UIScrollViewDelegate>

@end

@implementation BigScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 设置大背景ScorllView
        [self bindBigScorllView];
        
    }
    return self;
}

#pragma mark - 设置大背景scorllView
- (void)bindBigScorllView {
    NSLog(@"~~~~~~~~~~~~~~~~~~~%@", NSStringFromCGRect(self.bounds));
    self.bigScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.bigScrollView.contentOffset = CGPointMake(0, 0);
    self.bigScrollView.delegate = self;
    self.bigScrollView.contentSize = CGSizeMake(5 * kScreenSizeWidth, 0);
    self.bigScrollView.pagingEnabled = YES;
    for (int i = 0; i < 5; i++) {
        self.myView = [[UIView alloc] initWithFrame:CGRectMake(i * kScreenSizeWidth, 0, kScreenSizeWidth, self.bigScrollView.frame.size.height)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        label.text = [NSString stringWithFormat:@"%d", i];
        self.myView.backgroundColor = [UIColor redColor];
        [self.myView addSubview:label];
        
        self.myView.tag = 100 + i;
        [self.bigScrollView addSubview:self.myView];
    }
    [self addSubview:self.bigScrollView];
    // 设置页面
    [self bindViews];
}

#pragma mark - 设置页面
- (void)bindViews {
    self.headlineView = [self.bigScrollView viewWithTag:100];
    self.entertainmentView = [self.bigScrollView viewWithTag:101];
    self.fashionView = [self.bigScrollView viewWithTag:102];
    self.sportView = [self.bigScrollView viewWithTag:103];
    self.technologyView = [self.bigScrollView viewWithTag:104];
}

@end
