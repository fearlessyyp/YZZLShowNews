//
//  WeatherHandle.h
//  ShowNews
//
//  Created by YYP on 16/6/25.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "City.h"
#import "Weather.h"

@interface WeatherHandle : NSObject
/// 存储城市列表的字典
@property (nonatomic, strong) NSMutableDictionary *cityListDic;

// 存储城市字典key的数组
@property (nonatomic, strong) NSMutableArray *cityKeyArr;
// 声明单例
singleton_interface(WeatherHandle)

#pragma mark - 根据城市获取当前天气

@end
