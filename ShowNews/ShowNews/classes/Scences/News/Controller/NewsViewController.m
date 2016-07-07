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
#import "NewsDetailViewController.h"
#import "NewsPhotoDetailViewController.h"
#import "NewsSpecialListViewController.h"

typedef NS_ENUM(NSUInteger, NewsType) {
    NewsTypePhotoSet,
    NewsTypeSpecial,
    NewsTypeArticle,
    NewsTypeUnknow,
};

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
@property (nonatomic, assign) int headlinePage;
/// 娱乐page
@property (nonatomic, assign) int entertainmentPage;
/// 时尚page
@property (nonatomic, assign) int fashionPage;
/// 体育page
@property (nonatomic, assign) int sportPage;
/// 科技page
@property (nonatomic, assign) int technologyPage;
/// 头条第一个cell 的scorllView
@property (nonatomic, strong) UIScrollView *headlineScrollView;
/// 头条第一个cell 的pageControl
@property (nonatomic, strong) SMPageControl *headLinePageControl;
/// 头条轮播图数量
@property (nonatomic, strong) NSArray *headLineScrollArr;
/// 头条标题
@property (nonatomic, strong) UILabel *headlineTitleLabel;
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

    [self setTableViewInfo:self.bigScrollView.headlineTableView dataArray:self.allHeadlineArr page:&_headlinePage url:NEWS_HEADLINE_URL key:@"T1348647909107"];
    [self setTableViewInfo:self.bigScrollView.entertainmentTableView dataArray:self.allEntertainmentArr page:&_entertainmentPage url:NEWS_ENTERTAINMENT_URL key:@"T1348648517839"];
    [self setTableViewInfo:self.bigScrollView.fashionTableView dataArray:self.allFashionArr page:&_fashionPage url:NEWS_FASHION_URL key:@"T1348650593803"];
    [self setTableViewInfo:self.bigScrollView.technologyTableView dataArray:self.allTechnologyArr page:&_technologyPage url:NEWS_TECHNOLOGY_URL key:@"T1348649580692"];
    [self setTableViewInfo:self.bigScrollView.sportTableView dataArray:self.allSportArr page:&_sportPage url:NEWS_SPORT_URL key:@"T1348649079062"];

}
#pragma mark - 配置tableView的设置
- (void)setTableViewInfo:(UITableView *)tableView dataArray:(NSMutableArray *)dataArray page:(int *)page url:(NSString *)url key:(NSString *)key {
    tableView.delegate = self;
    tableView.dataSource = self;
    // 注册tableViewCell
    [tableView registerClass:[NewsFirstViewCell class] forCellReuseIdentifier:@"NewsFirstViewCell"];
    [tableView registerNib:[UINib nibWithNibName:@"NewsPhotoSetCell" bundle:nil] forCellReuseIdentifier:@"NewsPhotoSetCell"];
    [tableView registerNib:[UINib nibWithNibName:@"NewsArticleCell" bundle:nil] forCellReuseIdentifier:@"NewsArticleCell"];
    [tableView registerNib:[UINib nibWithNibName:@"NewsArticleCell" bundle:nil] forCellReuseIdentifier:@"NewsSpecialCell"];
    __weak typeof(self)weakSelf = self;
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [dataArray removeAllObjects];
        *page = 0;
        
        [weakSelf requestWithUrl:[NSString stringWithFormat:url, *page] dataArray:dataArray key:key tableView:tableView];
    }];
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        *page += 20;
        [weakSelf requestWithUrl:[NSString stringWithFormat:url, *page] dataArray:dataArray key:key tableView:tableView];
    }];
}

#pragma mark - 停止刷新动画
- (void)endRefresh:(UITableView *)tableView {
    [tableView.mj_header endRefreshing];
    [tableView.mj_footer endRefreshing];
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
            [self setScrollView:self.headlineScrollView pageControll:self.headLinePageControl dataArray:self.headLineScrollArr titleLabel:self.headlineTitleLabel];
        }
    }
}

#pragma mark - 设置轮播图与pageControl的关系
- (void)setScrollView:(UIScrollView *)scorllView pageControll:(SMPageControl *)pageControl dataArray:(NSArray *)dataArray titleLabel:(UILabel *)titleLabel{
    int temp = scorllView.contentOffset.x / kScreenSizeWidth;
    if (temp == 0) {
        pageControl.currentPage = dataArray.count - 1;
        titleLabel.text = [dataArray[dataArray.count - 1] title];
        scorllView.contentOffset = CGPointMake(dataArray.count * kScreenSizeWidth, 0);
    } else if (temp > 0 && temp < dataArray.count + 1) {
        pageControl.currentPage = temp - 1;
        titleLabel.text = [dataArray[temp - 1] title];
    } else {
        pageControl.currentPage = 0;
        titleLabel.text = [dataArray[0] title];
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
     News *news;
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
                    model.skipType = resultDict[@"tag"];
                    if ([self newsTypeWithNews:model] != NewsTypeUnknow) {
                        [imageArr addObject:model];
                    }
                }
                cell.imageArr = imageArr;
                [cell addAllViews];
                cell.titleLabel.text = news.title;
                self.headlineTitleLabel = cell.titleLabel;
                // 设置轮播图属性
                self.headLineScrollArr = imageArr;
                self.headlineScrollView = cell.scrollView;
                self.headlineScrollView.delegate = self;
                self.headLinePageControl = cell.pageControl;
                // 取消选中效果
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                // 添加轻拍手势
                [self addTapGestureToScrollView:self.headlineScrollView dataArray:self.headLineScrollArr];
                return cell;
            }else {
                if (news.skipType == nil) {
                    NewsArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsArticleCell" forIndexPath:indexPath];
                    [cell bindData:news];
                    return cell;
                } else if ([news.skipType isEqualToString:@"special"]) {
                    NewsArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsSpecialCell" forIndexPath:indexPath];
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
                cell.imageArr = imageArr;
                [cell addAllViews];
                cell.titleLabel.text = news.title;
                // 设置轮播图属性
                self.entertainmentScrollArr = imageArr;
                self.entertainmentScrollView = cell.scrollView;
                // 取消选中效果
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                // 添加轻拍手势
                [self addTapGestureToScrollView:self.entertainmentScrollView dataArray:self.entertainmentScrollArr];
                return cell;
            }else {
                if (news.skipType == nil) {
                    NewsArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsArticleCell" forIndexPath:indexPath];
                    [cell bindData:news];
                    return cell;
                } else if ([news.skipType isEqualToString:@"special"]) {
                    NewsArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsSpecialCell" forIndexPath:indexPath];
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
    } else if (tableView == self.bigScrollView.fashionTableView) {
        news = self.allFashionArr[indexPath.row];
        if (self.allFashionArr.count > 0) {
            if (indexPath.row == 0) {
                NewsFirstViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsFirstViewCell" forIndexPath:indexPath];
                NSMutableArray *imageArr = [NSMutableArray array];
                [imageArr addObject:news];
                cell.imageArr = imageArr;
                [cell addAllViews];
                cell.titleLabel.text = news.title;
                // 设置轮播图属性
                self.fashionScrollArr = imageArr;
                self.fashionScrollView = cell.scrollView;
                // 取消选中效果
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                // 添加轻拍手势
                [self addTapGestureToScrollView:self.fashionScrollView dataArray:self.fashionScrollArr];
                return cell;
            }else {
                if (news.skipType == nil) {
                    NewsArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsArticleCell" forIndexPath:indexPath];
                    [cell bindData:news];
                    return cell;
                } else if ([news.skipType isEqualToString:@"special"]) {
                    NewsArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsSpecialCell" forIndexPath:indexPath];
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
    } else if (tableView == self.bigScrollView.sportTableView) {
        news = self.allSportArr[indexPath.row];
        if (self.allSportArr.count > 0) {
            if (indexPath.row == 0) {
                NewsFirstViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsFirstViewCell" forIndexPath:indexPath];
                NSMutableArray *imageArr = [NSMutableArray array];
                [imageArr addObject:news];
                cell.imageArr = imageArr;
                [cell addAllViews];
                cell.titleLabel.text = news.title;
                // 设置轮播图属性
                self.sportScrollArr = imageArr;
                self.sportScrollView = cell.scrollView;
                // 取消选中效果
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                // 添加轻拍手势
                [self addTapGestureToScrollView:self.sportScrollView dataArray:self.sportScrollArr];
                return cell;
            } else {
                if (news.skipType == nil) {
                    NewsArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsArticleCell" forIndexPath:indexPath];
                    [cell bindData:news];
                    return cell;
                } else if ([news.skipType isEqualToString:@"special"]) {
                    NewsArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsSpecialCell" forIndexPath:indexPath];
                    cell.typeLabel.text = @"专题";
                    [cell bindData:news];
                    return cell;
                } else {
                    NewsPhotoSetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsPhotoSetCell" forIndexPath:indexPath];
                    [cell bindData:news];
                    return cell;
                }
            }
        }
    } else if (tableView == self.bigScrollView.technologyTableView) {
        news = self.allTechnologyArr[indexPath.row];
        if (self.allTechnologyArr.count > 0) {
            if (indexPath.row == 0) {
                NewsFirstViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsFirstViewCell" forIndexPath:indexPath];
                NSMutableArray *imageArr = [NSMutableArray array];
                [imageArr addObject:news];
                cell.imageArr = imageArr;
                [cell addAllViews];
                 cell.titleLabel.text = news.title;
                // 设置轮播图属性
                self.technologyScrollArr = imageArr;
                self.technologyScrollView = cell.scrollView;
                // 取消选中效果
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                // 添加轻拍手势
                [self addTapGestureToScrollView:self.technologyScrollView dataArray:self.technologyScrollArr];
                return cell;
            } else {
                if (news.skipType == nil) {
                    NewsArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsArticleCell" forIndexPath:indexPath];
                    [cell bindData:news];
                    return cell;
                } else if ([news.skipType isEqualToString:@"special"]) {
                    NewsArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsSpecialCell" forIndexPath:indexPath];
                    cell.typeLabel.text = @"专题";
                    [cell bindData:news];
                    return cell;
                } else {
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

#pragma mark - 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView cellForRowAtIndexPath:indexPath].selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        return;
    }
    int flag = (int)self.bigScrollView.bigScrollView.contentOffset.x / kScreenSizeWidth;
    News *news = [[News alloc] init];
    switch (flag) {
        case 0:
            news = self.allHeadlineArr[indexPath.row];
            break;
        case 1:
            news = self.allEntertainmentArr[indexPath.row];
            break;
        case 2:
            news = self.allFashionArr[indexPath.row];
            break;
        case 3:
            news = self.allSportArr[indexPath.row];
            break;
        case 4:
            news = self.allTechnologyArr[indexPath.row];
        default:
            break;
    }
    [self skipToDetailOrListWithNews:news];
}

#pragma mark - 请求数据
- (void)requestData {
    [self requestWithUrl:[NSString stringWithFormat:NEWS_HEADLINE_URL, self.headlinePage] dataArray:self.allHeadlineArr key:@"T1348647909107" tableView:self.bigScrollView.headlineTableView];
    [self requestWithUrl:[NSString stringWithFormat:NEWS_ENTERTAINMENT_URL, self.entertainmentPage] dataArray:self.allEntertainmentArr key:@"T1348648517839" tableView:self.bigScrollView.entertainmentTableView];
    [self requestWithUrl:[NSString stringWithFormat:NEWS_FASHION_URL, self.fashionPage] dataArray:self.allFashionArr key:@"T1348650593803" tableView:self.bigScrollView.fashionTableView];
    [self requestWithUrl:[NSString stringWithFormat:NEWS_SPORT_URL, self.sportPage] dataArray:self.allSportArr key:@"T1348649079062" tableView:self.bigScrollView.sportTableView];
    [self requestWithUrl:[NSString stringWithFormat:NEWS_TECHNOLOGY_URL, self.technologyPage] dataArray:self.allTechnologyArr key:@"T1348649580692" tableView:self.bigScrollView.technologyTableView];
}

- (void)requestWithUrl:(NSString *)url dataArray:(NSMutableArray *)dataArray key:(NSString *)key tableView:(UITableView *)tableView{
    [self.session GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *resultArr = responseObject[key];
        for (NSDictionary *resultDict in resultArr) {
            News *news = [[News alloc] init];
            [news setValuesForKeysWithDictionary:resultDict];
            if ([self newsTypeWithNews:news] != NewsTypeUnknow) {
                [dataArray addObject:news];
            }
        }
        // 停止刷新动画
        [self endRefresh:tableView];
        dispatch_async(dispatch_get_main_queue(), ^{
            [tableView reloadData];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
#warning 提醒
        // 停止刷新动画
        [self endRefresh:tableView];
        NSLog(@"数据请求失败");
    }];
}

#pragma mark - 给轮播大图添加轻拍手势
- (void)addTapGestureToScrollView:(UIScrollView *)scrollView dataArray:(NSArray *)dataArray {
    if (scrollView == self.headlineScrollView) {
        for (int i = 0; i < dataArray.count + 2; i++) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headlineTapGestureAction:)];
            [[scrollView viewWithTag:300 + i] addGestureRecognizer:tap];
        }
    } else {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
        [[scrollView viewWithTag:301] addGestureRecognizer:tap];
    }
}

#pragma mark - 轮播大图轻拍手势实现
// 头条
- (void)headlineTapGestureAction:(UITapGestureRecognizer *)tap {
    int temp = self.headlineScrollView.contentOffset.x / kScreenSizeWidth;
    News *news;
    if (temp == 0) {
       news = self.headLineScrollArr[self.headLineScrollArr.count - 1];
    } else if (temp > 0 && temp < self.headLineScrollArr.count + 1) {
        news = self.headLineScrollArr[temp - 1];
    } else {
        news = self.headLineScrollArr[0];
    }
    [self skipToDetailOrListWithNews:news];
}

- (void)tapGestureAction:(UITapGestureRecognizer *)tap {
    int flag = (int)self.bigScrollView.bigScrollView.contentOffset.x / kScreenSizeWidth;
    News *news = [[News alloc] init];
    switch (flag) {
        case 1:
            news = self.entertainmentScrollArr[0];
            break;
        case 2:
            news = self.fashionScrollArr[0];
            break;
        case 3:
            news = self.sportScrollArr[0];
            break;
        case 4:
            news = self.technologyScrollArr[0];
        default:
            break;
    }
    [self skipToDetailOrListWithNews:news];
}

#pragma mark - 返回新闻类型
- (NewsType)newsTypeWithNews:(News *)news {
    if (news.skipType == nil) {
        return NewsTypeArticle;
    } else if ([news.skipType isEqualToString:@"special"]) {
        return NewsTypeSpecial;
    } else if ([news.skipType isEqualToString:@"photoset"]) {
        return NewsTypePhotoSet;
    }
    return NewsTypeUnknow;
}

#pragma mark - 跳转详情页面
- (void)skipToDetailOrListWithNews:(News *)news {
    switch ([self newsTypeWithNews:news]) {
        case NewsTypeArticle:{
            NewsDetailViewController *newsDetailVC = [[NewsDetailViewController alloc] init];
            newsDetailVC.news = news;
            newsDetailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:newsDetailVC animated:YES];
            break;
        }
        case NewsTypePhotoSet:{
            NewsPhotoDetailViewController *newsPhotoVC = [[NewsPhotoDetailViewController alloc] init];
            newsPhotoVC.news = news;
            newsPhotoVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:newsPhotoVC animated:YES];
            break;
        }
        case NewsTypeSpecial:{
            NewsSpecialListViewController *newsSpecialVC = [[NewsSpecialListViewController alloc] init];
            newsSpecialVC.news = news;
            newsSpecialVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:newsSpecialVC animated:YES];
            break;
        }
        case NewsTypeUnknow:
#warning 提醒
            NSLog(@"unknow");
            break;
        default:
            break;
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.bigScrollView.headlineTableView reloadData];
    [self.bigScrollView.entertainmentTableView reloadData];
    [self.bigScrollView.fashionTableView reloadData];
    [self.bigScrollView.sportTableView reloadData];
    [self.bigScrollView.technologyTableView reloadData];
}



@end
