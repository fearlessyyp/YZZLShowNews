//
//  Singleton.h
//  ShowNews
//
//  Created by YYP on 16/6/13.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#ifndef Singleton_h
#define Singleton_h

// 单例的声明
// ## 拼接
// \回车 换行
#define singleton_interface(className) \
+ (instancetype)shared##className;

// 单例实现
#define singleton_implementation(className) \
static className *manager = nil; \
+ (instancetype)shared##className { \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
    manager = [[[self class] alloc] init]; \
}); \
return manager; \
}



#endif /* Singleton_h */
