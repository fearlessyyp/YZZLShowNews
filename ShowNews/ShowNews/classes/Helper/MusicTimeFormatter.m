//
//  MusicTimeFormatter.m
//  Project-Music01
//
//  Created by lanou3g on 15/10/29.
//  Copyright © 2015年 dingyuwei. All rights reserved.
//

#import "MusicTimeFormatter.h"

@implementation MusicTimeFormatter


// 格式化后的字符串
+ (NSString *)getStringFormatBySeconds:(float)seconds{
    // 格式化时间 从浮点类型转换成"00:00"字符串
    NSString *formatTime = [NSString stringWithFormat:@"%02ld:%02ld",(NSInteger)seconds / 60,(NSInteger)seconds % 60];
    return formatTime;
}

+ (float)getSecondsFormatByString:(NSString *)string{
    NSArray *tempArr = [string componentsSeparatedByString:@":"];
    return [[tempArr firstObject]integerValue] * 60.0 + [[tempArr lastObject]integerValue];
}

@end
