//
//  RootViewController.h
//  ShowNews
//
//  Created by YYP on 16/6/25.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UINavigationController
/// 城市名称
@property (nonatomic, strong) UILabel *city;
/// 显示实时天气的label
@property (nonatomic, strong) UILabel *weatherLabel;
/// 实时气温
@property (nonatomic, copy) NSString *temperature;
/// 实时天气
@property (nonatomic, copy) NSString *weather;
/// 显示天气的图标
@property (nonatomic, strong) UIImageView *iconImage;
/// 代表天气的代码
@property (nonatomic, strong) NSString *weatherNum;
@end
