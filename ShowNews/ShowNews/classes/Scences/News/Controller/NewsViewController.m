//
//  NewsViewController.m
//  ShowNews
//
//  Created by YYP on 16/6/25.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import "NewsViewController.h"
#import "SegmentView.h"
#import "BigScrollView.h"

@interface NewsViewController ()<SegmentViewDelegate, UIScrollViewDelegate>
/// 自定义SegmentView
@property (nonatomic, strong) SegmentView *segmentView;
/// 大背景
@property (nonatomic, strong) BigScrollView *bigScrollView;
//
//@property (nonatomic, strong) UIView *myView;
///// 头条
//@property (nonatomic, strong) UIView *headlineView;
///// 娱乐
//@property (nonatomic, strong) UIView *entertainmentView;
///// 时尚
//@property (nonatomic, strong) UIView *fashionView;
///// 体育
//@property (nonatomic, strong) UIView *sportView;
///// 科技
//@property (nonatomic, strong) UIView *technologyView;


@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"全世界 朝我看";
    // 设置自定义segmentView
    [self bindSegmentView];

    // 设置大背景ScorllView
    [self bindBigScorllView];

}

#pragma mark - 设置自定义segmentView
- (void)bindSegmentView {
    self.segmentView = [[SegmentView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 30)];
    self.segmentView.backgroundColor = [UIColor clearColor];
    self.segmentView.titleArray = @[@"头条",@"娱乐",@"时尚",@"体育",@"科技"];
    [self.segmentView.scrollLine setBackgroundColor:[UIColor clearColor]];
    self.segmentView.titleSelectedColor = [UIColor redColor];
    
    self.segmentView.touchDelegate = self;
    [self.view addSubview:self.segmentView];
}

#pragma mark - SegmentViewDelegate方法
- (void)touchLabelWithIndex:(NSInteger)index {
        self.bigScrollView.bigScrollView.contentOffset = CGPointMake(index * kScreenSizeWidth, 0);
}

#pragma mark - 设置大背景scorllView
- (void)bindBigScorllView {
    
    BigScrollView *bigScrollView = [[BigScrollView alloc] initWithFrame:CGRectMake(0, 30, kScreenSizeWidth, kScreenSizeHeight - kNavigationAndStatusHeight - 30)];
    self.bigScrollView = bigScrollView;
    self.bigScrollView.bigScrollView.delegate = self;
    [self.view addSubview:self.bigScrollView];
}

#pragma mark - UIScrollViewDelegate 
// 实现代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.bigScrollView.bigScrollView) {
        // 滑动bigScrollView结束后改变自定义SegmentView上选中的label
        [self.segmentView selectLabelWithIndex:self.bigScrollView.bigScrollView.contentOffset.x / kScreenSizeWidth];
    } else {
        
    }
}

@end
