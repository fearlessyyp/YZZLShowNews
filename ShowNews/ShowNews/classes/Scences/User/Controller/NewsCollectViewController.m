//
//  NewsCollectViewController.m
//  ShowNews
//
//  Created by ZZQ on 16/7/1.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import "NewsCollectViewController.h"
#import "News.h"
#import "NewsPhotoDetailViewController.h"
#import "NewsPhotoSetCell.h"
#import "NewsDetailViewController.h"
#import "NewsArticleCell.h"
#import "NewsSpecialListViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "DataBaseHandle.h"

typedef NS_ENUM(NSUInteger, NewsType) {
    NewsTypePhotoSet,
    NewsTypeSpecial,
    NewsTypeArticle,
    NewsTypeUnknow,
};

@interface NewsCollectViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *allNewsArray;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation NewsCollectViewController

#pragma mark - 懒加载
- (NSMutableArray *)allNewsArray {
    if (!_allNewsArray) {
        _allNewsArray = [NSMutableArray array];
    }
    return _allNewsArray;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"新闻收藏";
    // 初始化tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenSizeWidth, kScreenSizeHeight - kNavigationAndStatusHeight + 44) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"NewsPhotoSetCell" bundle:nil] forCellReuseIdentifier:@"NewsPhotoSetCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"NewsArticleCell" bundle:nil] forCellReuseIdentifier:@"NewsArticleCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"NewsArticleCell" bundle:nil] forCellReuseIdentifier:@"NewsSpecialCell"];


}

#pragma mark - 请求数据
- (void)requestData {
    NSString *cql = [NSString stringWithFormat:@"select * from %@ where username = ?", @"News"];
    NSArray *pvalues =  @[[AVUser currentUser].username];
    [self.allNewsArray removeAllObjects];
    [AVQuery doCloudQueryInBackgroundWithCQL:cql pvalues:pvalues callback:^(AVCloudQueryResult *result, NSError *error) {
        if (!error) {
            // 操作成功
            for (AVObject *obj in result.results) {
                News *news = [[DataBaseHandle sharedDataBaseHandle] aVObjectToNews:obj];
                [self.allNewsArray addObject:news];
            }
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error);
        }
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
#warning 提醒
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
