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
#define kNavigationAndStatusHeight (self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height)

// 屏幕高度
#define kScreenSizeHeight [UIScreen mainScreen].bounds.size.height
// 屏幕宽度
#define kScreenSizeWidth [UIScreen mainScreen].bounds.size.width

// tabbar和navigationbar的图片


#endif /* EfficientDefine_h */
