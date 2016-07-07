//
//  BaseViewController.m
//  ShowNews
//
//  Created by YYP on 16/6/25.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import "BaseViewController.h"
#import <Masonry.h>
#import <RESideMenu.h>
#import "UIImage+ImageByColor.h"
#import "PlayerManager.h"
#import "MusicSearchController.h"

// 导航栏高度
#define kNavHeight self.navigationController.navigationBar.frame.size.height
// 图标的尺寸
#define kIconSize CGSizeMake(kNavHeight * 0.5, kNavHeight * 0.5)
@interface BaseViewController ()
@property (nonatomic, strong) UIView *myView;
@end

@implementation BaseViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initLayout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)initLayout {
   
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"redPacket_btn_1@2x"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:NEWS_MAIN_COLOR] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"musicBarButton"] style:UIBarButtonItemStylePlain target:self action:@selector(presentRightMenuView:)];

    __weak typeof(self)weakSelf = self;
    // 初始化自定义视图
    self.myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width * 0.2, kNavHeight)];
    // 自定义视图左按钮
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.myView];
    // 初始化显示天气图标
    self.iconImage = [UIImageView new];
    self.iconImage.backgroundColor = [UIColor yellowColor];
    [self.myView addSubview:self.iconImage];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.myView);
        make.right.equalTo(weakSelf.myView);
        make.size.mas_equalTo(kIconSize);
    }];

    // 初始化显示城市的label
    self.cityLabel = [UILabel new];
    self.cityLabel.backgroundColor = [UIColor purpleColor];
    [self.myView addSubview:self.cityLabel];
    [self.cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.myView);
        make.left.equalTo(weakSelf.myView);
        make.right.equalTo(weakSelf.iconImage.mas_left);
        make.height.equalTo(weakSelf.iconImage.mas_height);
    }];
    
    // 初始化显示天气的label
    self.weatherLabel = [UILabel new];
    self.weatherLabel.backgroundColor = [UIColor cyanColor];
    [self.myView addSubview:self.weatherLabel];
    [self.weatherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.cityLabel.mas_bottom);
        make.bottom.equalTo(weakSelf.myView);
        make.right.equalTo(weakSelf.myView);
        make.left.equalTo(weakSelf.myView);
    }];

    self.button = [UIButton new];
    self.button.backgroundColor = [UIColor clearColor];
    [self.myView addSubview:self.button];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.myView);
        make.left.equalTo(weakSelf.myView);
        make.bottom.equalTo(weakSelf.myView);
        make.right.equalTo(weakSelf.myView);
    }];
    [self.button addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
}

- (void)test {
    NSLog(@"===========");
}


- (void)presentRightMenuView:(UIBarButtonItem *)sender {
//    [[PlayerManager sharePlayer] requestData:[MusicSearchController sharedMusicSearchController]];
    [self presentRightMenuViewController:sender];
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
