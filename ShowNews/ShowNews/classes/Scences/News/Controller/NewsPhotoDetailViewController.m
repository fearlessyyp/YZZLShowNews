//
//  NewsPhotoDetailViewController.m
//  ShowNews
//
//  Created by YYP on 16/7/2.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import "NewsPhotoDetailViewController.h"
#import <AFNetworking.h>
#import "NewsUrl.h"
#import "NewsImage.h"
#import "UIImageView+WebCache.h"
#import "NewsPSetTableViewCell.h"
#import "ToolForHeight.h"
#import <UMSocial.h>
#import <AVOSCloud/AVOSCloud.h>
#import "DataBaseHandle.h"
#import <MBProgressHUD.h>

#define kSetNameFont 14
#define kNoteFont 12
#define kPageWidth 50

@interface NewsPhotoDetailViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UMSocialUIDelegate>
@property (nonatomic, strong) AFHTTPSessionManager *session;

@property (nonatomic, strong) UITableView *tableView;
// 文字滚动
@property (nonatomic, strong) UIScrollView *textScrollView;
// 文字背景view
@property (nonatomic, strong) UIView *backgroundView;
// setnamelabel
@property (nonatomic, strong) UILabel *setNameLabel;
// 当前显示当前图片是第几张
@property (nonatomic, strong) UILabel *imgsumLabel;
// 详情
@property (nonatomic, strong) UILabel *noteLabel;
// 记录textScrollView滑动前offset
@property (nonatomic, assign) int lastOffSet;
// 第几张图片
@property (nonatomic, assign) int temp;

/// 是否被收藏
@property (nonatomic, assign) BOOL isCollect;
/// 数据库中存储的id
@property (nonatomic, strong) NSString *objectId;
@end

@implementation NewsPhotoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    // 创建TableView
    [self initTableView];
    // 设置scrollViews
    [self setScrollViews];
    // 解析数据
    [self requestData];
}

#pragma mark - 创建tableView
- (void)initTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenSizeHeight, kScreenSizeWidth) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor blackColor];
    CGAffineTransform at = CGAffineTransformMakeRotation(-M_PI/2);
    self.tableView.transform = at;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.pagingEnabled = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.center = CGPointMake(kScreenSizeWidth / 2 ,(kScreenSizeHeight - 64) / 2);
    [self.view addSubview:self.tableView];
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"NewsPSetTableViewCell" bundle:nil] forCellReuseIdentifier:@"NewsPSetTableViewCell"];
}


#pragma mark - 设置ScrollViews
- (void)setScrollViews {
    // 配置半透明背景view
    self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenSizeHeight - 200, kScreenSizeWidth, 136)];
    self.backgroundView.backgroundColor = NEWS_COLOR(0, 0, 0, 0.4);
    [self.view addSubview:self.backgroundView];
    // 添加轻扫手势
    [self addSwipeGestureRecognizers];
    // 配置小标题label
    self.setNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, kScreenSizeWidth - 10 - kPageWidth, 20)];
    //    self.setNameLabel.backgroundColor = [UIColor purpleColor];
    self.setNameLabel.textColor = [UIColor whiteColor];
    self.setNameLabel.font = [UIFont systemFontOfSize:kSetNameFont];
    [self.backgroundView addSubview:self.setNameLabel];
    // 配置页数label
    self.imgsumLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.setNameLabel.frame), 0, kPageWidth, 20)];
    self.imgsumLabel.textColor = [UIColor whiteColor];
    self.imgsumLabel.font = [UIFont systemFontOfSize:kNoteFont];
    self.imgsumLabel.textAlignment = NSTextAlignmentRight;
    [self.backgroundView addSubview:self.imgsumLabel];
}

#pragma mark - 添加轻扫手势
- (void)addSwipeGestureRecognizers {
    UISwipeGestureRecognizer *upSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(upSwipeAction:)];
    upSwipe.direction = UISwipeGestureRecognizerDirectionUp;
    [self.backgroundView addGestureRecognizer:upSwipe];
    
    UISwipeGestureRecognizer *downSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(downSwipeAction:)];
    downSwipe.direction = UISwipeGestureRecognizerDirectionDown;
    [self.backgroundView addGestureRecognizer:downSwipe];
}
#pragma mark - 向上轻扫手势触发的事件
- (void)upSwipeAction:(UISwipeGestureRecognizer *)sender {
    if (self.backgroundView.frame.origin.y == kScreenSizeHeight - 200 && self.backgroundView.frame.size.height > 136) {
        [UIView animateWithDuration:0.3 animations:^{
            self.backgroundView.frame = CGRectMake(0, kScreenSizeHeight - 64 - CGRectGetHeight(self.backgroundView.frame), kScreenSizeWidth, CGRectGetHeight(self.backgroundView.frame));
        }];
    }
}
#pragma mark - 向下轻扫手势触发的事件
- (void)downSwipeAction:(UISwipeGestureRecognizer *)sender {
    if (self.backgroundView.frame.origin.y != kScreenSizeHeight - 200) {
        [UIView animateWithDuration:0.3 animations:^{
            self.backgroundView.frame = CGRectMake(0, kScreenSizeHeight - 200, kScreenSizeWidth, CGRectGetHeight(self.backgroundView.frame));
        }];
    }
}

#pragma mark - scrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == self.textScrollView) {
        self.lastOffSet = (int)scrollView.contentOffset.y;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        self.temp = self.tableView.contentOffset.y / kScreenSizeWidth;
        
        self.imgsumLabel.text = [NSString stringWithFormat:@"%d/%@", self.temp + 1, self.news.imgsum];
        self.noteLabel.text = [NSString stringWithFormat:@"%@ %@", [self.news.photos[self.temp] imgtitle], [self.news.photos[self.temp] note]];
        CGFloat noteHeight = [ToolForHeight textHeightWithText:self.noteLabel.text font:[UIFont systemFontOfSize:kNoteFont] width:kScreenSizeWidth - 10];
        self.noteLabel.frame = CGRectMake(5, 20, kScreenSizeWidth - 10, 20 + noteHeight);
        self.backgroundView.frame = CGRectMake(0, kScreenSizeHeight - 200, kScreenSizeWidth, self.noteLabel.frame.size.height + self.setNameLabel.frame.size.height);
    }
}


#pragma mark - 解析数据
- (void)requestData {
    self.session = [AFHTTPSessionManager manager];
    self.session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"application/x-json",@"text/html", @"application/x-javascript", nil];
    __weak typeof(self)weakSelf = self;
    NSArray *skipArray = [self.news.skipID componentsSeparatedByString:@"|"];
    if (skipArray.count > 1) {
        [self.session GET:NEWS_PHOTOSET_DETAIL_URL([skipArray[0] substringFromIndex:4], skipArray[1]) parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [weakSelf.news setValuesForKeysWithDictionary:responseObject];
            weakSelf.news.photos = [NSMutableArray array];
            for (NSDictionary *dict in responseObject[@"photos"]) {
                NewsImage *newsImage = [[NewsImage alloc] init];
                [newsImage setValuesForKeysWithDictionary:dict];
                [weakSelf.news.photos addObject:newsImage];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
            
            NSLog(@"请求成功");
            // 设置文字滚动视图
            [weakSelf layoutTextScrollView];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"请求失败");
        }];
    }
}

#pragma mark - 设置文字滚动视图
- (void)layoutTextScrollView {
    if (self.news.photos.count > 0) {
        self.setNameLabel.text = self.news.setname;
        self.imgsumLabel.text = [NSString stringWithFormat:@"1/%@", self.news.imgsum];
        CGFloat noteHeight = [ToolForHeight textHeightWithText:[NSString stringWithFormat:@"%@ %@", [self.news.photos[0] imgtitle], [self.news.photos[0] note]] font:[UIFont systemFontOfSize:kNoteFont] width:kScreenSizeWidth - 10];
        // 配置分页内容label
        self.noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 20, kScreenSizeWidth - 10, noteHeight)];
        self.noteLabel.textColor = [UIColor whiteColor];
        self.noteLabel.numberOfLines = 0;
        self.noteLabel.text = [NSString stringWithFormat:@"%@ %@", [self.news.photos[0] imgtitle], [self.news.photos[0] note]];
        self.noteLabel.font = [UIFont systemFontOfSize:kNoteFont];
        [self.backgroundView addSubview:self.noteLabel];
        self.backgroundView.frame = CGRectMake(0, kScreenSizeHeight - 200, kScreenSizeWidth, self.noteLabel.frame.size.height + self.setNameLabel.frame.size.height);
    }
    
}


#pragma mark - TableView的代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.news.photos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsPSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsPSetTableViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor blackColor];
    cell.photoImageView.backgroundColor = [UIColor blackColor];
    CGAffineTransform at = CGAffineTransformMakeRotation(M_PI/2);
    cell.transform = at;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.center = CGPointMake(self.view.frame.size.height / 2 ,tableView.center.x);
    cell.photoImageView.contentMode = UIViewContentModeScaleAspectFit;
    [cell.photoImageView sd_setImageWithURL:[NSURL URLWithString:[self.news.photos[indexPath.row] imgurl]]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kScreenSizeWidth;
}



#pragma mark - 右按钮
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIBarButtonItem *collectItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"newscollect"] style:UIBarButtonItemStylePlain target:self action:@selector(collectItemAction:)];
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"newsshare"] style:UIBarButtonItemStylePlain target:self action:@selector(shareAction:)];
    self.navigationItem.rightBarButtonItems = @[shareItem, collectItem];
    // 查询是否被该用户收藏过
    [self selectFromNewsTable:collectItem];

}

#pragma mark - 收藏
- (void)collectItemAction:(UIBarButtonItem *)sender {
    if (self.isCollect) {
        // 删除逻辑
        NSString *cql = @"delete from News where objectId = ?";
        NSArray *pvalues =  @[self.objectId];
        [AVQuery doCloudQueryInBackgroundWithCQL:cql pvalues:pvalues callback:^(AVCloudQueryResult *result, NSError *error) {
            // 如果 error 为空，说明保存成功
            if (!error) {
                // 删除成功
                sender.image = [[UIImage imageNamed:@"newscollect"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                self.isCollect = NO;
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"取消收藏成功";
                hud.margin = 10.f;
                hud.yOffset = 0.f;
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:1];
            } else {
                NSLog(@"~~~~~~error = %@", error);
            }
        }];
        
    } else {
        // 存储逻辑
        AVObject *object = [[DataBaseHandle sharedDataBaseHandle] newsToAVObject:self.news];
        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                // 从表中获取数据->objectID
                [self selectFromNewsTable:sender];
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"收藏成功";
                hud.margin = 10.f;
                hud.yOffset = 0.f;
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:1];
            } else {
                NSLog(@"!!!error = %@", error);
            }
        }];
    }
    

}

#pragma mark - 分享
- (void)shareAction:(UIBarButtonItem *)sender {
    
    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:self.news.imgsrc];
    
    //分享内嵌文字
    NSString *shareText = [NSString stringWithFormat:@"%@", self.news.title];
    [UMSocialData defaultData].extConfig.wechatSessionData.url = self.news.url;
    
    //分享样式数组
    NSArray *shareArr = [NSArray arrayWithObjects:UMShareToSina,UMShareToQzone,UMShareToQQ,UMShareToWechatSession,UMShareToWechatTimeline, nil];
    
    [UMSocialSnsService presentSnsIconSheetView:self appKey:UmengAppkey shareText:shareText shareImage:nil shareToSnsNames:shareArr delegate:self];

}

- (void)selectFromNewsTable:(UIBarButtonItem *)collectItem {
    NSString *cql = [NSString stringWithFormat:@"select * from %@ where username = ? and postid = ?", @"News"];
    NSArray *pvalues =  @[@1, self.news.postid];
    [AVQuery doCloudQueryInBackgroundWithCQL:cql pvalues:pvalues callback:^(AVCloudQueryResult *result, NSError *error) {
        if (!error) {
            // 操作成功
            if (result.results.count > 0) {
                AVObject *obj = result.results[0];
                self.objectId = obj.objectId;
                collectItem.image = [[UIImage imageNamed:@"newscollected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                self.isCollect = YES;
            }
        } else {
            NSLog(@"%@", error);
        }
    }];
}

@end
