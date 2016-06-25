//
//  City.m
//  ShowNews
//
//  Created by YYP on 16/6/25.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import "City.h"

@implementation City

// 防崩
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.Id = value;
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@", self.city];
}

@end
