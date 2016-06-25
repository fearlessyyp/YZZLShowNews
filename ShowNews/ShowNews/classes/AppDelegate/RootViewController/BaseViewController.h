//
//  BaseViewController.h
//  ShowNews
//
//  Created by YYP on 16/6/25.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
/// 城市名称
@property (nonatomic, strong) UILabel *cityLabel;
/// 显示实时天气的label
@property (nonatomic, strong) UILabel *weatherLabel;
/// 显示天气的图标
@property (nonatomic, strong) UIImageView *iconImage;

// 设置天气

@end
