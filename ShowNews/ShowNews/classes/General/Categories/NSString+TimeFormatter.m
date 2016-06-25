//
//  NSString+TimeFormatter.m
//  UI项目MusicPlay
//
//  Created by lanou3g on 16/6/14.
//  Copyright © 2016年 雷坤. All rights reserved.
//

#import "NSString+TimeFormatter.h"

@implementation NSString (TimeFormatter)

// 200 -> 03:20

+ (NSString *)getStringWithTime:(CGFloat)second
{
    return [NSString stringWithFormat:@"%02ld:%02ld",(NSInteger)second / 60, (NSInteger)second % 60];
}


// 03:20 -> 200
+ (CGFloat)getSecondWithString:(NSString *)string
{
    NSArray *array = [string componentsSeparatedByString:@":"];
    return [[array firstObject] integerValue] * 60 + [[array lastObject] integerValue];

}


- (CGFloat)getSecondWithString
{
    NSArray *array = [self componentsSeparatedByString:@":"];
    return [[array firstObject] integerValue] * 60 + [[array lastObject] integerValue];

}







@end
