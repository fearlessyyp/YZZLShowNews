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
#import <AFNetworking.h>
#import "NewsUrl.h"
#import "News.h"
#import <MJRefresh.h>
#import "NewsPhotoSetCell.h"
#import "NewsArticleCell.h"
#import "NewsFirstViewCell.h"
#import <SMPageControl.h>


@interface NewsViewController ()<SegmentViewDelegate, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
/// 自定义SegmentView
@property (nonatomic, strong) SegmentView *segmentView;
/// 大背景
@property (nonatomic, strong) BigScrollView *bigScrollView;
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
/// 用于网络请求的session
@property (nonatomic, strong) AFHTTPSessionManager *session;
/// 头条page
@property (nonatomic, assign) NSInteger headlinePage;
/// 娱乐page
@property (nonatomic, assign) NSInteger entertainmentPage;
/// 时尚page
@property (nonatomic, assign) NSInteger fashionPage;
/// 体育page
@property (nonatomic, assign) NSInteger sportPage;
/// 科技page
@property (nonatomic, assign) NSInteger technologyPage;
/// 头条第一个cell 的scorllView
@property (nonatomic, strong) UIScrollView *headlineScrollView;
/// 头条第一个cell 的pageControl
@property (nonatomic, strong) SMPageControl *headLinePageControl;
/// 头条轮播图数量
@property (nonatomic, strong) NSArray *headLineScrollArr;
/// 娱乐第一个cell 的scorllView
@property (nonatomic, strong) UIScrollView *entertainmentScrollView;
/// 娱乐第一个cell 的pageControl
@property (nonatomic, strong) SMPageControl *entertainmentPageControl;
/// 娱乐轮播图数量
@property (nonatomic, strong) NSArray *entertainmentScrollArr;
/// 时尚第一个cell 的scorllView
@property (nonatomic, strong) UIScrollView *fashionScrollView;
/// 时尚第一个cell 的pageControl
@property (nonatomic, strong) SMPageControl *fashionPageControl;
/// 时尚轮播图数量
@property (nonatomic, strong) NSArray *fashionScrollArr;
/// 体育第一个cell 的scorllView
@property (nonatomic, strong) UIScrollView *sportScrollView;
/// 体育第一个cell 的pageControl
@property (nonatomic, strong) SMPageControl *sportPageControl;
/// 体育轮播图数量
@property (nonatomic, strong) NSArray *sportScrollArr;
/// 科技第一个cell 的scorllView
@property (nonatomic, strong) UIScrollView *technologyScrollView;
/// 科技第一个cell 的pageControl
@property (nonatomic, strong) SMPageControl *technologyPageControl;
/// 科技轮播图数量
@property (nonatomic, strong) NSArray *technologyScrollArr;
@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"全世界 朝我看";
    // 设置自定义segmentView
    [self bindSegmentView];
    // 设置大背景ScorllView
    [self bindBigScorllView];
    // 解析数据
    [self requestData];
    
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

- (AFHTTPSessionManager *)session {
    if (!_session) {
        _session = [AFHTTPSessionManager manager];
    }
    return _session;
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

    [self setTableViewInfo:self.bigScrollView.headlineTableView];
    [self setTableViewInfo:self.bigScrollView.entertainmentTableView];
    [self setTableViewInfo:self.bigScrollView.fashionTableView];
    [self setTableViewInfo:self.bigScrollView.technologyTableView];
    [self setTableViewInfo:self.bigScrollView.sportTableView];

}
#pragma mark - 配置tableView的设置
- (void)setTableViewInfo:(UITableView *)tableView {
    tableView.delegate = self;
    tableView.dataSource = self;
    // 注册tableViewCell
    [tableView registerClass:[NewsFirstViewCell class] forCellReuseIdentifier:@"NewsFirstViewCell"];
    [tableView registerNib:[UINib nibWithNibName:@"NewsPhotoSetCell" bundle:nil] forCellReuseIdentifier:@"NewsPhotoSetCell"];
    [tableView registerNib:[UINib nibWithNibName:@"NewsArticleCell" bundle:nil] forCellReuseIdentifier:@"NewsArticleCell"];
}


#pragma mark - UIScrollViewDelegate 
// 实现代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int flag = (int)self.bigScrollView.bigScrollView.contentOffset.x / kScreenSizeWidth;
    if (scrollView == self.bigScrollView.bigScrollView) {
        // 滑动bigScrollView结束后改变自定义SegmentView上选中的label
        [self.segmentView selectLabelWithIndex:self.bigScrollView.bigScrollView.contentOffset.x / kScreenSizeWidth];
    } else {
        if (flag == 0) {
            // 设置头条轮播图
            [self setScrollView:self.headlineScrollView pageControll:self.headLinePageControl dataArray:self.headLineScrollArr];
        } else if (flag == 1) {
            // 设置娱乐轮播图
            [self setScrollView:self.entertainmentScrollView pageControll:self.entertainmentPageControl dataArray:self.entertainmentScrollArr];
        } else if (flag == 2) {
            // 设置时尚轮播图
            [self setScrollView:self.fashionScrollView pageControll:self.fashionPageControl dataArray:self.fashionScrollArr];
        } else if (flag == 3) {
            // 设置体育轮播图
            [self setScrollView:self.sportScrollView pageControll:self.sportPageControl dataArray:self.sportScrollArr];
        } else if (flag == 4) {
            // 设置科技轮播图
            [self setScrollView:self.technologyScrollView pageControll:self.technologyPageControl dataArray:self.technologyScrollArr];
        }
    }
}

#pragma mark - 设置轮播图与pageControl的关系
- (void)setScrollView:(UIScrollView *)scorllView pageControll:(SMPageControl *)pageControl dataArray:(NSArray *)dataArray {
    int temp = scorllView.contentOffset.x / kScreenSizeWidth;
    if (temp == 0) {
        pageControl.currentPage = dataArray.count - 1;
        scorllView.contentOffset = CGPointMake(dataArray.count * kScreenSizeWidth, 0);
    } else if (temp > 0 && temp < self.headLineScrollArr.count + 1) {
        pageControl.currentPage = temp - 1;
    } else {
        pageControl.currentPage = 0;
        scorllView.contentOffset = CGPointMake(kScreenSizeWidth, 0);
    }
}

#pragma mark - tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.bigScrollView.headlineTableView) {
        return self.allHeadlineArr.count;
    } else if (tableView == self.bigScrollView.entertainmentTableView) {
        return self.allEntertainmentArr.count;
    } else if (tableView == self.bigScrollView.fashionTableView) {
        return self.allFashionArr.count;
    } else if (tableView == self.bigScrollView.sportTableView) {
        return self.allSportArr.count;
    } else if (tableView == self.bigScrollView.technologyTableView){
        return self.allTechnologyArr.count;
    }
    return 0;
}

#pragma mark - 返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     News *news = [[News alloc] init];
    if (tableView == self.bigScrollView.headlineTableView) {
        news = self.allHeadlineArr[indexPath.row];
        if (self.allHeadlineArr.count > 0) {
            if (indexPath.row == 0) {
                NewsFirstViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsFirstViewCell" forIndexPath:indexPath];
                NSMutableArray *imageArr = [NSMutableArray array];
                [imageArr addObject:news];
                for (NSDictionary *resultDict in news.ads) {
                    News *model = [[News alloc] init];
                    [model setValuesForKeysWithDictionary:resultDict];
                    model.skipID = resultDict[@"url"];
                    [imageArr addObject:model];
                }
                cell.imageArr = imageArr;
                
                [cell addAllViews];
                // 设置轮播图属性
                self.headLineScrollArr = imageArr;
                self.headlineScrollView = cell.scrollView;
                self.headlineScrollView.delegate = self;
                self.headLinePageControl = cell.pageControl;
                return cell;
            }else {
                if (news.skipType == nil) {
                    NewsArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsArticleCell" forIndexPath:indexPath];
                    [cell bindData:news];
                    return cell;
                } else if ([news.skipType isEqualToString:@"special"]) {
                    NewsArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsArticleCell" forIndexPath:indexPath];
                    cell.typeLabel.text = @"专题";
                    [cell bindData:news];
                    return cell;
                }else {
                    NewsPhotoSetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsPhotoSetCell" forIndexPath:indexPath];
                    [cell bindData:news];
                    return cell;
                }
            }
        }
    } else if (tableView == self.bigScrollView.entertainmentTableView) {
        news = self.allEntertainmentArr[indexPath.row];
        if (self.allEntertainmentArr.count > 0) {
            if (indexPath.row == 0) {
                NewsFirstViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsFirstViewCell" forIndexPath:indexPath];
                NSMutableArray *imageArr = [NSMutableArray array];
                [imageArr addObject:news];
                for (NSDictionary *resultDict in news.ads) {
                    News *model = [[News alloc] init];
                    [model setValuesForKeysWithDictionary:resultDict];
                    model.skipID = resultDict[@"url"];
                    [imageArr addObject:model];
                }
                cell.imageArr = imageArr;
                
                [cell addAllViews];
                // 设置轮播图属性
                self.entertainmentScrollArr = imageArr;
                self.entertainmentScrollView = cell.scrollView;
                self.entertainmentScrollView.delegate = self;
                self.entertainmentPageControl = cell.pageControl;
                return cell;
            }else {
                if (news.skipType == nil) {
                    NewsArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsArticleCell" forIndexPath:indexPath];
                    [cell bindData:news];
                    return cell;
                } else if ([news.skipType isEqualToString:@"special"]) {
                    NewsArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsArticleCell" forIndexPath:indexPath];
                    cell.typeLabel.text = @"专题";
                    [cell bindData:news];
                    return cell;
                }else {
                    NewsPhotoSetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsPhotoSetCell" forIndexPath:indexPath];
                    [cell bindData:news];
                    return cell;
                }
            }
        }
    }
#warning ??????????????????????
    else if (tableView == self.bigScrollView.fashionTableView) {
        news = self.allFashionArr[indexPath.row];
        if (self.allFashionArr.count > 0) {
            if (indexPath.row == 0) {
                NewsFirstViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsFirstViewCell" forIndexPath:indexPath];
                NSMutableArray *imageArr = [NSMutableArray array];
                [imageArr addObject:news];
                for (NSDictionary *resultDict in news.ads) {
                    News *model = [[News alloc] init];
                    [model setValuesForKeysWithDictionary:resultDict];
                    model.skipID = resultDict[@"url"];
                    [imageArr addObject:model];
                }
                cell.imageArr = imageArr;
                
                [cell addAllViews];
                // 设置轮播图属性
                self.fashionScrollArr = imageArr;
                self.fashionScrollView = cell.scrollView;
                self.fashionScrollView.delegate = self;
                self.fashionPageControl = cell.pageControl;
                return cell;
            }else {
                if (news.skipType == nil) {
                    NewsArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsArticleCell" forIndexPath:indexPath];
                    [cell bindData:news];
                    return cell;
                } else if ([news.skipType isEqualToString:@"special"]) {
                    NewsArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsArticleCell" forIndexPath:indexPath];
                    cell.typeLabel.text = @"专题";
                    [cell bindData:news];
                    return cell;
                }else {
                    NewsPhotoSetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsPhotoSetCell" forIndexPath:indexPath];
                    [cell bindData:news];
                    return cell;
                }
            }
        }
    }
    else if (tableView == self.bigScrollView.sportTableView) {
        news = self.allSportArr[indexPath.row];
        if (self.allSportArr.count > 0) {
            if (indexPath.row == 0) {
                NewsFirstViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsFirstViewCell" forIndexPath:indexPath];
                NSMutableArray *imageArr = [NSMutableArray array];
                [imageArr addObject:news];
                for (NSDictionary *resultDict in news.ads) {
                    News *model = [[News alloc] init];
                    [model setValuesForKeysWithDictionary:resultDict];
                    model.skipID = resultDict[@"url"];
                    [imageArr addObject:model];
                }
                cell.imageArr = imageArr;
                
                [cell addAllViews];
                // 设置轮播图属性
                self.sportScrollArr = imageArr;
                self.sportScrollView = cell.scrollView;
                self.sportScrollView.delegate = self;
                self.sportPageControl = cell.pageControl;
                return cell;
            }else {
                if (news.skipType == nil) {
                    NewsArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsArticleCell" forIndexPath:indexPath];
                    [cell bindData:news];
                    return cell;
                } else if ([news.skipType isEqualToString:@"special"]) {
                    NewsArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsArticleCell" forIndexPath:indexPath];
                    cell.typeLabel.text = @"专题";
                    [cell bindData:news];
                    return cell;
                }else {
                    NewsPhotoSetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsPhotoSetCell" forIndexPath:indexPath];
                    [cell bindData:news];
                    return cell;
                }
            }
        }
    }
    else if (tableView == self.bigScrollView.technologyTableView) {
        news = self.allTechnologyArr[indexPath.row];
        if (self.allTechnologyArr.count > 0) {
            if (indexPath.row == 0) {
                NewsFirstViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsFirstViewCell" forIndexPath:indexPath];
                NSMutableArray *imageArr = [NSMutableArray array];
                [imageArr addObject:news];
                for (NSDictionary *resultDict in news.ads) {
                    News *model = [[News alloc] init];
                    [model setValuesForKeysWithDictionary:resultDict];
                    model.skipID = resultDict[@"url"];
                    [imageArr addObject:model];
                }
                cell.imageArr = imageArr;
                
                [cell addAllViews];
                // 设置轮播图属性
                self.technologyScrollArr = imageArr;
                self.technologyScrollView = cell.scrollView;
                self.technologyScrollView.delegate = self;
                self.technologyPageControl = cell.pageControl;
                return cell;
            }else {
                if (news.skipType == nil) {
                    NewsArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsArticleCell" forIndexPath:indexPath];
                    [cell bindData:news];
                    return cell;
                } else if ([news.skipType isEqualToString:@"special"]) {
                    NewsArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsArticleCell" forIndexPath:indexPath];
                    cell.typeLabel.text = @"专题";
                    [cell bindData:news];
                    return cell;
                }else {
                    NewsPhotoSetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsPhotoSetCell" forIndexPath:indexPath];
                    [cell bindData:news];
                    return cell;
                }
            }
        }
    }
    return nil;
}


#pragma mark - cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 150;
    }
    return 100;
}

#pragma mark - 请求数据
- (void)requestData {
    [self.allHeadlineArr removeAllObjects];
    [self.allEntertainmentArr removeAllObjects];
    [self.allFashionArr removeAllObjects];
    [self.allSportArr removeAllObjects];
    [self.allTechnologyArr removeAllObjects];
    [self requestWithUrl:NEWS_HEADLINE_URL(self.headlinePage) dataArray:self.allHeadlineArr key:@"T1348647909107" tableView:self.bigScrollView.headlineTableView];
    [self requestWithUrl:NEWS_ENTERTAINMENT_URL(self.entertainmentPage) dataArray:self.allEntertainmentArr key:@"T1348648517839" tableView:self.bigScrollView.entertainmentTableView];
    [self requestWithUrl:NEWS_FASHION_URL(self.fashionPage) dataArray:self.allFashionArr key:@"T1348650593803" tableView:self.bigScrollView.fashionTableView];
    [self requestWithUrl:NEWS_SPORT_URL(self.sportPage) dataArray:self.allSportArr key:@"T1348650593803" tableView:self.bigScrollView.sportTableView];
    [self requestWithUrl:NEWS_TECHNOLOGY_URL(self.technologyPage) dataArray:self.allTechnologyArr key:@"T1348649580692" tableView:self.bigScrollView.technologyTableView];
}

- (void)requestWithUrl:(NSString *)url dataArray:(NSMutableArray *)dataArray key:(NSString *)key tableView:(UITableView *)tableView{
    [self.session GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"数据请求成功");
        NSArray *resultArr = responseObject[key];
        for (NSDictionary *resultDict in resultArr) {
            News *news = [[News alloc] init];
            [news setValuesForKeysWithDictionary:resultDict];
            if (!([news.skipType isEqualToString:@"live"] && [news.skipType isEqualToString:@"video"])) {
                [dataArray addObject:news];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [tableView reloadData];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
    }];
}

@end
