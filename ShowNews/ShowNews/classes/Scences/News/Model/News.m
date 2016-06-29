//
//  News.m
//  ShowNews
//
//  Created by YYP on 16/6/27.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import "News.h"

@implementation News

// 防崩
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {

}

- (NSString *)description {
    return [NSString stringWithFormat:@"title = %@ array = %@", self.title, self.ads];
}

@end
