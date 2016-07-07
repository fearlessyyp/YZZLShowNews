//
//  NewsDetailViewController.m
//  ShowNews
//
//  Created by YYP on 16/6/29.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "NewsUrl.h"
#import <AFNetworking.h>
#import "NewsImage.h"
#import <UMSocial.h>
#import "DataBaseHandle.h"
#import <AVOSCloud/AVOSCloud.h>
#import <MBProgressHUD.h>
#import "LoginViewController.h"

@interface NewsDetailViewController ()<UMSocialUIDelegate>
@property (nonatomic, strong) AFHTTPSessionManager *session;
@property (nonatomic, strong) UIWebView *webView;
/// 是否被收藏
@property (nonatomic, assign) BOOL isCollect;
/// 数据库中存储的id
@property (nonatomic, strong) NSString *objectId;
@end

@implementation NewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"新闻详情";
    // 请求数据
    [self requestData];
    
}

#pragma mark - 请求数据
- (void)requestData {
    self.session = [AFHTTPSessionManager manager];
    // 设置请求返回支持的文件类型
    self.session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"application/x-json",@"text/html", @"application/x-javascript", nil];
    __weak typeof(self)weakSelf = self;
    [self.session GET:NEWS_ARTICLE_DETAIL_URL(self.news.postid) parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *resultDict = responseObject[weakSelf.news.postid];
        [weakSelf.news setValuesForKeysWithDictionary:resultDict];
        self.news.images = [NSMutableArray array];
        for (NSDictionary *dict in resultDict[@"img"]) {
            NewsImage *newsImage = [NewsImage detailImgWithDict:dict];
            [weakSelf.news.images addObject:newsImage];
        }
        // 在webView中显示
        [weakSelf showInWebView];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
#warning 提醒用户
        NSLog(@"请求失败 error %@", error);
    }];
}

#pragma mark - 在webView中展示
- (void)showInWebView {
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenSizeWidth, kScreenSizeHeight - kNavigationAndStatusHeight + 44)];
    [self.view addSubview:_webView];
    self.webView.backgroundColor = [UIColor clearColor];
    
    NSMutableString *html = [NSMutableString string];
    [html appendString:@"<html>"];
    [html appendString:@"<head>"];
    [html appendFormat:@"<link rel=\"stylesheet\" href=\"%@\">",[[NSBundle mainBundle] URLForResource:@"Details.css" withExtension:nil]];
    [html appendString:@"<style>"];
    
    [html appendString:@"</style>"];
    [html appendString:@"</head>"];
    
    [html appendString:@"<body style=\"font-size:14px\">"];
    [html appendString:[self touchBody]];
    [html appendString:@"</body>"];
    
    [html appendString:@"</html>"];
    
    [self.webView loadHTMLString:html baseURL:nil];
}


- (NSString *)touchBody
{
    
    NSMutableString *body = [NSMutableString string];
    [body appendFormat:@"<div class=\"title\">%@</div>",self.news.title];
    [body appendFormat:@"<div class=\"time\">%@</div>",[NSString stringWithFormat:@"%@ %@", self.news.source, self.news.ptime]];
    if (self.news.digest.length > 0) {
        [body appendFormat:@"<div class=\"digest\">%@</div>",self.news.digest];
    }
    if (self.news.body != nil) {
        [body appendString:self.news.body];
    }
    
    // 遍历img
    for (NewsImage *detailImgModel in self.news.images) {
        NSMutableString *imgHtml = [NSMutableString string];
        
        // 设置img的div
        [imgHtml appendString:@"<div class=\"img-parent\">"];
        
        // 数组存放被切割的像素
        NSArray *pixel = [detailImgModel.pixel componentsSeparatedByString:@"*"];
        CGFloat width = [[pixel firstObject]floatValue];
        CGFloat height = [[pixel lastObject]floatValue];
        // 判断是否超过最大宽度
        CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width * 0.96;
        if (width > maxWidth) {
            height = maxWidth / width * height;
            width = maxWidth;
        }
        
        NSString *onload = @"this.onclick = function() {"
        "  window.location.href = 'sx:src=' +this.src;"
        "};";
        [imgHtml appendFormat:@"<img onload=\"%@\" width=\"%f\" height=\"%f\" src=\"%@\">",onload,width,height,detailImgModel.src];
        // 结束标记
        [imgHtml appendString:@"</div>"];
        [imgHtml appendFormat:@"<div class=\"alt\">%@</div>", detailImgModel.alt];
        
        
        
        // 替换标记
        [body replaceOccurrencesOfString:detailImgModel.ref withString:imgHtml options:NSCaseInsensitiveSearch range:NSMakeRange(0, body.length)];
    }
    return body;
}



#pragma mark - 右按钮
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIBarButtonItem *collectItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"newscollect"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(collectItemAction:)];
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"newsshare"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(shareAction:)];
    self.navigationItem.rightBarButtonItems = @[shareItem, collectItem];
    // 查询是否被该用户收藏过
    [self selectFromNewsTable:collectItem];
}

#pragma mark - 收藏
- (void)collectItemAction:(UIBarButtonItem *)sender {
    if ([AVUser currentUser]) {
        if (self.isCollect) {
            // 删除逻辑
            NSString *cql = @"delete from News where objectId = ?";
            NSArray *pvalues =  @[self.objectId];
            [AVQuery doCloudQueryInBackgroundWithCQL:cql pvalues:pvalues callback:^(AVCloudQueryResult *result, NSError *error) {
                // 如果 error 为空，说明删除成功
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
    } else {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    
   
}

#pragma mark - 分享
- (void)shareAction:(UIBarButtonItem *)sender {
    
    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:self.news.imgsrc];
    
    //分享内嵌文字
    NSString *shareText = [NSString stringWithFormat:@"%@", self.news.title];
    [UMSocialData defaultData].extConfig.wechatSessionData.url = self.news.shareLink;
    
    //分享样式数组
    NSArray *shareArr = [NSArray arrayWithObjects:UMShareToSina,UMShareToQzone,UMShareToQQ,UMShareToWechatSession,UMShareToWechatTimeline, nil];
    
    [UMSocialSnsService presentSnsIconSheetView:self appKey:UmengAppkey shareText:shareText shareImage:nil shareToSnsNames:shareArr delegate:self];
    
}

#pragma mark - 从news表中获取数据
- (void)selectFromNewsTable:(UIBarButtonItem *)collectItem {
    if ([AVUser currentUser]) {
        NSString *cql = [NSString stringWithFormat:@"select * from %@ where username = ? and postid = ?", @"News"];
        NSArray *pvalues =  @[[AVUser currentUser].username, self.news.postid];
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
}

@end
