//
//  Simple.h
//  ShowNews
//
//  Created by ZZQ on 16/7/1.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
@interface Simple : NSObject

singleton_interface(Simple);
// 分子
@property (nonatomic, assign) float size;
// 比例
@property (nonatomic, assign) float scale;
// 夜间模式
@property (nonatomic, assign) NSInteger moon;

@end
