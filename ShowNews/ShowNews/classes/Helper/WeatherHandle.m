//
//  WeatherHandle.m
//  ShowNews
//
//  Created by YYP on 16/6/25.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import "WeatherHandle.h"
#import <AFNetworking.h>
#import "NewsUrl.h"
#import "GetPinYinFromChinese.h"

@interface WeatherHandle ()


/// 用于网络请求的session
@property (nonatomic, strong) AFHTTPSessionManager *session;

@end
static WeatherHandle *manager = nil;
@implementation WeatherHandle
// 实现单例

+ (instancetype)sharedWeatherHandle {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[[self class] alloc] init];
        manager.session = [AFHTTPSessionManager manager];
        // 获取城市列表
        [manager requestCityData];
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

#pragma mark - 获取城市列表
- (void)requestCityData {
    __weak typeof(self) weakSelf = self;
    [self.session GET:WEATHER_ALLCITY parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"解析数据成功");
        
        NSDictionary *resultDict = responseObject;
        for (NSDictionary *dic in resultDict[@"city_info"]) {
            City *city = [[City alloc] init];
            [city setValuesForKeysWithDictionary:dic];
            city.pinyin = [GetPinYinFromChinese getChinesePinYin:city.city];
            // 拼音首字母
            NSString *pinyin = [city.pinyin substringToIndex:1];
            // 如果该字母已经在这个数组中，则不添加，反之将字母添加到数组中，并作为大字典的key，object为一个可变的空数组。
            if (![weakSelf.cityKeyArr containsObject:pinyin]) {
                [weakSelf.cityKeyArr addObject:pinyin];
                [weakSelf.cityListDic setObject:[NSMutableArray array] forKey:pinyin];
            }
            // 根据拼音首字母取出对应的数组
            NSMutableArray *array = [weakSelf.cityListDic objectForKey:pinyin];
            [array addObject:city];
        }
        // 给城市字典排序
        [self sortCity];
        NSLog(@"%@", self.cityListDic);
        NSString *documentsStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *fileStr = [documentsStr stringByAppendingPathComponent:@"city.json"];
        BOOL result = [self.cityListDic writeToFile:fileStr atomically:YES];
        NSLog(@" %d fileStr = %@", result, fileStr);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求所有城市信息失败 %@", error);
    }];
}

#pragma mark - 给城市字典排序
- (void)sortCity {
    // 给字典中的数组包含的元素按拼音排序
    for (NSString *key in self.cityListDic) {
        NSMutableArray *array = self.cityListDic[key];
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"pinyin" ascending:YES];
        [array sortUsingDescriptors:@[sort]];
    }
    // 给存kay的数组排序
    [self.cityKeyArr sortUsingSelector:@selector(compare:)];
}
@end
