//
//  NewsPhotoSetDetailViewController.m
//  ShowNews
//
//  Created by YYP on 16/6/29.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import "NewsPhotoSetDetailViewController.h"
#import <AFNetworking.h>
#import "NewsUrl.h"
#import "NewsImage.h"
#import "UIImageView+WebCache.h"
#import "ToolForHeight.h"
#import <Masonry.h>
#import "UIImage+ImageByColor.h"
#import <MBProgressHUD.h>

#define kSetNameFont 14
#define kNoteFont 12
#define kPageWidth 50

@interface NewsPhotoSetDetailViewController ()<UIScrollViewDelegate>
// 返回按钮
@property (nonatomic, strong) UIButton *backButton;
// 图片滚动
@property (nonatomic, strong) UIScrollView *imageScrollView;
// 文字滚动
@property (nonatomic, strong) UIScrollView *textScrollView;

@property (nonatomic, strong) AFHTTPSessionManager *session;

// 图片
@property (nonatomic, strong) UIImageView *imageView;

// 存储文字高度
@property (nonatomic, assign) CGFloat textHeight;
// 文字背景view
@property (nonatomic, strong) UIView *backgroundView;
// setnamelabel
@property (nonatomic, strong) UILabel *setNameLabel;
// 当前显示当前图片是第几张
@property (nonatomic, strong) UILabel *imgsumLabel;
// 详情
@property (nonatomic, strong) UILabel *noteLabel;

// 存储图片信息
@property (nonatomic, strong) NSMutableDictionary *imageDict;

@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation NewsPhotoSetDetailViewController

#pragma mark - 懒加载
- (NSMutableDictionary *)imageDict {
    if (!_imageDict) {
        _imageDict = [NSMutableDictionary dictionary];
    }
    return _imageDict;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
//    [self.navigationController setNavigationBarHidden:YES];
    
    // 注册通知中心
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getImageHeight:) name:@"imageHeight" object:nil];

    
    // 设置scrollViews
    [self setScrollViews];

    // 解析数据
    [self requestData];
    
}


#pragma mark - 设置ScrollViews
- (void)setScrollViews {
    self.imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenSizeWidth, kScreenSizeHeight)];
    //    self.imageScrollView.backgroundColor = [UIColor whiteColor];
    self.imageScrollView.pagingEnabled = YES;
    self.imageScrollView.delegate = self;
    [self.view addSubview:self.imageScrollView];
    
    
    self.textScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kScreenSizeHeight - 200, kScreenSizeWidth, 136)];
    self.textScrollView.delegate = self;
    
    //    self.textScrollView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.textScrollView];
    // 配置半透明背景view
    self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSizeWidth, kScreenSizeHeight)];
    self.backgroundView.backgroundColor = NEWS_COLOR(0, 0, 0, 0.4);
    [self.textScrollView addSubview:self.backgroundView];
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
    
    self.hud = [[MBProgressHUD alloc] initWithView:self.imageScrollView];
    [self.hud show:YES];
    
}


//- (void)getImageHeight:(NSNotification *)notification {
//    NSString *strT = [notification userInfo][@"url"];
//    [self.imageDict setObject:[notification userInfo][@"image"] forKey:[NSString stringWithFormat:@"%@",strT]];
//    
//    
//    if ([self.imageDict allKeys].count == self.news.photos.count) {
//        for (int i = 0; i < self.news.photos.count; i++) {
//            UIImageView *imageView = [self.imageScrollView viewWithTag:(400 + i)];
//            NSString *str = [self.news.photos[i] imgurl];
//            UIImage *img = [self.imageDict objectForKey:str];
//            imageView.frame = CGRectMake(i * kScreenSizeWidth, 0, kScreenSizeWidth, [ToolForHeight imageHeightWithImage:img]);
//            imageView.center = CGPointMake(i * kScreenSizeWidth + kScreenSizeWidth / 2, self.imageScrollView.frame.size.height / 2 - 64);
//        }
//        [self.hud hide:YES];
//    }
//}
//


#pragma mark - scrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.imageScrollView) {
        int temp = self.imageScrollView.contentOffset.x / kScreenSizeWidth;
        
        UIImageView *imageView = [self.imageScrollView viewWithTag:(400 + temp)];
        
        
        self.imgsumLabel.text = [NSString stringWithFormat:@"%d/%@", temp + 1, self.news.imgsum];
        self.noteLabel.text = [NSString stringWithFormat:@"%@ %@", [self.news.photos[temp] imgtitle], [self.news.photos[temp] note]];
        CGFloat noteHeight = [ToolForHeight textHeightWithText:[NSString stringWithFormat:@"%@ %@", [self.news.photos[temp] imgtitle], [self.news.photos[temp] note]] font:[UIFont systemFontOfSize:kNoteFont] width:kScreenSizeWidth - 10];
        self.noteLabel.frame = CGRectMake(5, 20, kScreenSizeWidth - 10, 20 + noteHeight);
        self.textScrollView.contentSize = CGSizeMake(kScreenSizeWidth, 40 + self.noteLabel.frame.size.height);
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
            NSLog(@"请求成功");
            // 设置图片滚动视图
            [weakSelf layoutImageScrollView];
            // 设置文字滚动视图
            [weakSelf layoutTextScrollView];
           
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"请求失败");
        }];
    }
    

}


#pragma mark - 返回按钮点击事件
- (void)backButtonAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 设置图片滚动视图
- (void)layoutImageScrollView {
    self.imageScrollView.contentSize = CGSizeMake(self.news.photos.count * kScreenSizeWidth, 0);
    for (int i = 0; i < self.news.photos.count; i++) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * kScreenSizeWidth, 0, kScreenSizeWidth, kScreenSizeHeight)];
        self.imageView.tag = 400 + i;
//        [self.imageView sd_setImageWithURL:[NSURL URLWithString:[self.news.photos[i] imgurl]] placeholderImage:[UIImage imageWithColor:NEWS_COLOR(0, 0, 0, 1)]];
        NSLog(@"~~~~~~~~~~~~~~~~~~~~%@", [self.news.photos[i] imgurl]);
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView.center = CGPointMake(i * kScreenSizeWidth + kScreenSizeWidth / 2, self.imageScrollView.frame.size.height / 2 - 64);
        [self.imageScrollView addSubview:self.imageView];
    }
    
}

//#pragma mark - 从网络上请求图片
//-(UIImage *) getImageFromURL:(NSString *)fileURL {
//    UIImage * result;
//    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
//    result = [UIImage imageWithData:data];
//    NSLog(@"请求图片");
//    return result;
//    
//    //    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
//    //    [imageView sd_setImageWithURL:[NSURL URLWithString:fileURL]];
//    //    return imageView.image;
//}

#pragma mark - 设置文字滚动视图
- (void)layoutTextScrollView {
    
   
    if (self.news.photos.count > 0) {
        self.setNameLabel.text = self.news.setname;
        self.imgsumLabel.text = [NSString stringWithFormat:@"1/%@", self.news.imgsum];
        CGFloat noteHeight = [ToolForHeight textHeightWithText:[NSString stringWithFormat:@"%@ %@", [self.news.photos[0] imgtitle], [self.news.photos[0] note]] font:[UIFont systemFontOfSize:kNoteFont] width:kScreenSizeWidth - 10];
        // 配置分页内容label
        self.noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 20, kScreenSizeWidth - 10, 20 + noteHeight)];
        self.noteLabel.textColor = [UIColor whiteColor];
        self.noteLabel.numberOfLines = 0;
//        self.noteLabel.backgroundColor = [UIColor purpleColor];
        self.noteLabel.text = [NSString stringWithFormat:@"%@ %@", [self.news.photos[0] imgtitle], [self.news.photos[0] note]];
        self.noteLabel.font = [UIFont systemFontOfSize:kNoteFont];
        [self.backgroundView addSubview:self.noteLabel];
        self.textScrollView.contentSize = CGSizeMake(kScreenSizeWidth, 40 + self.noteLabel.frame.size.height);
    }
    
}




- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:NEWS_COLOR(0, 0, 0, 1)] forBarMetrics:UIBarMetricsDefault];
}


-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
