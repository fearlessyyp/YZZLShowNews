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
#import <UIImageView+WebCache.h>
#import "ToolForHeight.h"
#import <Masonry.h>

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

@end

@implementation NewsPhotoSetDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self.navigationController setNavigationBarHidden:YES];
    // 解析数据
    [self requestData];
   

    
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
            // 设置返回按钮
            [weakSelf layoutBackButton];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"请求失败");
        }];
    }
    

}

#pragma mark - 设置返回按钮
- (void)layoutBackButton {
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.frame = CGRectMake(20, 20, 40, 40);
    [self.backButton setTitle:@"返回" forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backButton];
}

#pragma mark - 返回按钮点击事件
- (void)backButtonAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 设置图片滚动视图
- (void)layoutImageScrollView {
    self.imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenSizeWidth, kScreenSizeHeight)];
    self.imageScrollView.pagingEnabled = YES;
    self.imageScrollView.delegate = self;
    self.imageScrollView.contentSize = CGSizeMake(self.news.photos.count * kScreenSizeWidth, 0);
    [self.view addSubview:self.imageScrollView];
    for (int i = 0; i < self.news.photos.count; i++) {
        UIImage *image = [self getImageFromURL:[self.news.photos[i] imgurl]];
        CGFloat height = [ToolForHeight imageHeightWithImage:image];

        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * kScreenSizeWidth, 0, kScreenSizeWidth, height)];
        self.imageView.backgroundColor = [UIColor whiteColor];
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:[self.news.photos[i] imgurl]]];
        self.imageView.center = CGPointMake(i * kScreenSizeWidth + kScreenSizeWidth / 2, kScreenSizeHeight / 2);
//        self.imageView.backgroundColor = [UIColor redColor];
        [self.imageScrollView addSubview:self.imageView];
    }
}

#pragma mark - 设置文字滚动视图
- (void)layoutTextScrollView {
    self.textScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kScreenSizeHeight - 150, kScreenSizeWidth, 150)];
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
        self.textScrollView.contentSize = CGSizeMake(kScreenSizeWidth, 40 + noteHeight);
    }
    
}


#pragma mark - 从网络上请求图片
-(UIImage *) getImageFromURL:(NSString *)fileURL {
    UIImage * result;
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    return result;
}




@end
