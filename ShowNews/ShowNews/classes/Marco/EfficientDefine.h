//
//  EfficientDefine.h
//  ShowNews
//
//  Created by YYP on 16/6/25.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#ifndef EfficientDefine_h
#define EfficientDefine_h


//-------------------打印日志-------------------------
//DEBUG  模式下打印日志,当前行
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif


//重写NSLog,Debug模式下打印日志和当前行数
#if DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"\nfunction:%s line:%d content:%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) nil
#endif

// Navigationbar + 状态栏高度
#define kNavigationAndStatusHeight 64 - 49

// 屏幕高度
#define kScreenSizeHeight [UIScreen mainScreen].bounds.size.height
// 屏幕宽度
#define kScreenSizeWidth [UIScreen mainScreen].bounds.size.width

// 颜色
#define NEWS_COLOR(r, g, b, a) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:a]

// 随机色
#define NEWS_RANDOM_COLOR DB_COLOR(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255), 1.0)

// 主题色213 25 37
#define NEWS_MAIN_COLOR NEWS_COLOR(213, 25, 37, 1.0)




#endif /* EfficientDefine_h */
