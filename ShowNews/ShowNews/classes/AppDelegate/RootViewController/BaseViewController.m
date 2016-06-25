//
//  BaseViewController.m
//  ShowNews
//
//  Created by YYP on 16/6/25.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import "BaseViewController.h"
#import <Masonry.h>
// 导航栏高度
#define kNavHeight self.navigationController.navigationBar.frame.size.height
// 图标的尺寸
#define kIconSize CGSizeMake(kNavHeight * 0.5, kNavHeight * 0.5)
@interface BaseViewController ()
@property (nonatomic, strong) UIView *myView;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"个人中心";
    [self initLayout];
}
- (void)initLayout {
    __weak typeof(self)weakSelf = self;
    // 初始化自定义视图
    self.myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width * 0.2, kNavHeight)];
    self.myView.backgroundColor = [UIColor redColor];
    // 自定义视图左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.myView];
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
