//
//  City.m
//  ShowNews
//
//  Created by LK on 16/6/26.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import "City.h"

@implementation City
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.Id = value;
    }
}
@end
