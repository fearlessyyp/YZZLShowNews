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

@interface NewsViewController ()<SegmentViewDelegate, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
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
/// 头条数据
@property (nonatomic, strong) NSMutableArray *allHeadlineArr;
/// 娱乐数据
@property (nonatomic, strong) NSMutableArray *allEntertainmentArr;
/// 时尚数据
@property (nonatomic, strong) NSMutableArray *allFashionArr;
/// 体育数据
@property (nonatomic, strong) NSMutableArray *allSportArr;
/// 科技数据
@property (nonatomic, strong) NSMutableArray *allTechnologyArr;


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

#pragma mark - 懒加载
- (NSMutableArray *)allHeadlineArr {
    if (!_allHeadlineArr) {
        _allHeadlineArr = [NSMutableArray array];
    }
    return _allHeadlineArr;
}

- (NSMutableArray *)allEntertainmentArr {
    if (!_allEntertainmentArr) {
        _allEntertainmentArr = [NSMutableArray array];
    }
    return _allEntertainmentArr;
}

- (NSMutableArray *)allFashionArr {
    if (!_allFashionArr) {
        _allFashionArr = [NSMutableArray array];
    }
    return _allFashionArr;
}

- (NSMutableArray *)allSportArr {
    if (!_allSportArr) {
        _allSportArr = [NSMutableArray array];
    }
    return _allSportArr;
}

- (NSMutableArray *)allTechnologyArr {
    if (!_allTechnologyArr) {
        _allTechnologyArr = [NSMutableArray array];
    }
    return _allTechnologyArr;
}

#pragma mark - 设置自定义segmentView
- (void)bindSegmentView {
    self.segmentView = [[SegmentView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 30)];
    self.segmentView.backgroundColor = [UIColor clearColor];
    self.segmentView.titleArray = @[@"头条",@"娱乐",@"时尚",@"体育",@"科技"];
    [self.segmentView.scrollLine setBackgroundColor:[UIColor clearColor]];
    self.segmentView.titleSelectedColor = NEWS_MAIN_COLOR;
    
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
    
    // 设置tableView的代理
    self.bigScrollView.headlineTableView.delegate = self;
    self.bigScrollView.headlineTableView.dataSource = self;
    self.bigScrollView.headlineTableView.backgroundColor = [UIColor redColor];
    
    self.bigScrollView.entertainmentTableView.delegate = self;
    self.bigScrollView.entertainmentTableView.dataSource = self;
    
    self.bigScrollView.fashionTableView.delegate = self;
    self.bigScrollView.fashionTableView.dataSource = self;
    
    self.bigScrollView.technologyTableView.delegate = self;
    self.bigScrollView.technologyTableView.dataSource = self;
    
    self.bigScrollView.sportTableView.delegate = self;
    self.bigScrollView.sportTableView.dataSource = self;
    
    // 注册tableViewCell
    [self.bigScrollView.headlineTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"headlineCell"];
    [self.bigScrollView.entertainmentTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"headlineCell"];
    [self.bigScrollView.fashionTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"headlineCell"];
    [self.bigScrollView.technologyTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"headlineCell"];
    [self.bigScrollView.sportTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"headlineCell"];



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

#pragma mark - tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.bigScrollView.headlineTableView) {
        return 1;
        return self.allHeadlineArr.count;
    } else if (tableView == self.bigScrollView.entertainmentTableView) {
        return 2;
        return self.allEntertainmentArr.count;
    } else if (tableView == self.bigScrollView.fashionTableView) {
        return 3;
        return self.allFashionArr.count;
    } else if (tableView == self.bigScrollView.sportTableView) {
        return 4;
        return self.allFashionArr.count;
    } else if (tableView == self.bigScrollView.technologyTableView){
        return 5;
        return self.allTechnologyArr.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"headlineCell" forIndexPath:indexPath];
    cell.textLabel.text = @"1";
    return cell;
}



@end
