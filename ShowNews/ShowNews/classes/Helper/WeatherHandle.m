//
//  WeatherHandle.m
//  ShowNews
//
//  Created by YYP on 16/6/25.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import "WeatherHandle.h"

@interface WeatherHandle ()
// 存储城市字典key的数组
@property (nonatomic, strong) NSMutableArray *cityKeyArr;


@end

@implementation WeatherHandle
// 实现单例
static WeatherHandle *manager = nil;
+ (instancetype)sharedWeatherHandle {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[[self class] alloc] init];
        
    });
    return manager;
}


#pragma mark - 懒加载
- (NSMutableArray *)cityKeyArr {
    if (!_cityKeyArr) {
        _cityKeyArr = [NSMutableArray array];
    }
    return _cityKeyArr;
}

- (NSMutableDictionary *)cityListDic {
    if (!_cityListDic) {
        _cityListDic = [NSMutableDictionary dictionary];
    }
    return _cityListDic;
}

@end
