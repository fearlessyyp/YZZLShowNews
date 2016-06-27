//
//  BigScrollView.h
//  ShowNews
//
//  Created by YYP on 16/6/26.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BigScrollView : UIView
/// 大背景
@property (nonatomic, strong) UIScrollView *bigScrollView;

@property (nonatomic, strong) UIView *myView;
/// 头条
@property (nonatomic, strong) UIView *headlineView;
/// 娱乐
@property (nonatomic, strong) UIView *entertainmentView;
/// 时尚
@property (nonatomic, strong) UIView *fashionView;
/// 体育
@property (nonatomic, strong) UIView *sportView;
/// 科技
@property (nonatomic, strong) UIView *technologyView;

@property (nonatomic, strong) UITableView *tableView;
@end
