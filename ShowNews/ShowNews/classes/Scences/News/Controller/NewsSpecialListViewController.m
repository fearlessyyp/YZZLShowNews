//
//  NewsListViewController.m
//  ShowNews
//
//  Created by YYP on 16/6/29.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import "NewsSpecialListViewController.h"
#import "NewsUrl.h"
#import "NewsPhotoDetailViewController.h"
#import "NewsPhotoSetCell.h"
#import "NewsDetailViewController.h"
#import "NewsArticleCell.h"
#import <AFNetworking.h>

typedef NS_ENUM(NSUInteger, NewsType) {
    NewsTypePhotoSet,
    NewsTypeSpecial,
    NewsTypeArticle,
    NewsTypeUnknow,
};


@interface NewsSpecialListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *allNewsArray;
@property (nonatomic, strong) AFHTTPSessionManager *session;
@end

@implementation NewsSpecialListViewController

#pragma mark - 懒加载
- (NSMutableArray *)allNewsArray {
    if (!_allNewsArray) {
        _allNewsArray = [NSMutableArray array];
    }
    return _allNewsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"列表";
    
    // 初始化tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenSizeWidth, kScreenSizeHeight - kNavigationAndStatusHeight + 44) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"NewsPhotoSetCell" bundle:nil] forCellReuseIdentifier:@"NewsPhotoSetCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"NewsArticleCell" bundle:nil] forCellReuseIdentifier:@"NewsArticleCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"NewsArticleCell" bundle:nil] forCellReuseIdentifier:@"NewsSpecialCell"];
    
    // 请求数据
    [self requestData];
    
}

#pragma mark - 请求数据
- (void)requestData {
    self.session = [AFHTTPSessionManager manager];
    // 设置请求返回支持的文件类型
    self.session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"application/x-json",@"text/html", @"application/x-javascript", nil];
    __weak typeof(self)weakSelf = self;
    [self.session GET:NEWS_SPECIAL_DETAIL_URL(self.news.skipID) parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *resultArr = [responseObject[self.news.skipID][@"topics"] firstObject][@"docs"];
        for (NSDictionary *dict in resultArr) {
            News *news = [[News alloc] init];
            [news setValuesForKeysWithDictionary:dict];
            if ([self newsTypeWithNews:news] != NewsTypeUnknow) {
                [weakSelf.allNewsArray addObject:news];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
#warning 提醒用户
        NSLog(@"请求失败");
    }];
}

#pragma mark - tableView相关代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allNewsArray.count;
}

#pragma mark - 返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    News *news = self.allNewsArray[indexPath.row];
//    news = self.allNewsArray[indexPath.row];
    switch ([self newsTypeWithNews:news]) {
        case NewsTypePhotoSet:{
            NewsPhotoSetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsPhotoSetCell" forIndexPath:indexPath];
            [cell bindData:news];
            return cell;
            break;
        }
        case NewsTypeArticle:{
            NewsArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsArticleCell" forIndexPath:indexPath];
            [cell bindData:news];
            return cell;
            break;
        }
        case NewsTypeSpecial:{
            NewsArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsSpecialCell" forIndexPath:indexPath];
            cell.typeLabel.text = @"专题";
            [cell bindData:news];
            return cell;
            break;
        }
        case NewsTypeUnknow:
            return nil;
            break;
        default:
            return nil;
            break;
    }
}

#pragma mark - 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView cellForRowAtIndexPath:indexPath].selectionStyle = UITableViewCellSelectionStyleNone;
    News *news = self.allNewsArray[indexPath.row];
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
//#warning 提醒
            NSLog(@"unknow");
            break;
        default:
            break;
    }
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backItemAction:)];
}

- (void)backItemAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
