//
//  City.h
//  ShowNews
//
//  Created by YYP on 16/6/25.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface City : NSObject

// 城市名称
@property (nonatomic, strong) NSString *city;

// Id
@property (nonatomic, strong) NSString *Id;

// 纬度
@property (nonatomic, strong) NSString *lat;

// 经度
@property (nonatomic, strong) NSString *lon;

// 所在省
@property (nonatomic, strong) NSString *prov;

@end
