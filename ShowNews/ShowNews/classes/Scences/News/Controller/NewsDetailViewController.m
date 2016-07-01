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

@interface NewsDetailViewController ()
@property (nonatomic, strong) AFHTTPSessionManager *session;
@property (nonatomic, strong) UIWebView *webView;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
