//
//  Music.m
//  ShowNews
//
//  Created by ZZQ on 16/6/25.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import "Music.h"

@implementation Music

// 只进一次
- (instancetype)init
{
    self = [super init];
    if (self) {
        // 实例化时间歌词的数组
        self.timeForLyric = [NSMutableArray array];
    }
    return self;
}

//以"\n"拆解字符串:"[00:00.000]ABCD","[00:00.000]BCDEF"
- (void)loadLyricWithStr:(NSString *)str {
    NSArray *bigArray = [str componentsSeparatedByString:@"\n"];
    for (NSString *temStr in bigArray) {
        if (![temStr isEqualToString:@""]) {
            //在使用"]"拆解字符串后的结果("[00:00.000]","ABCD")
            NSArray *lyricAndTimeArr = [temStr componentsSeparatedByString:@"]"];
            //将时间拆解成想要的格式:"00:00"，以作为字典的key
            NSString *timeKey = [lyricAndTimeArr[0] substringWithRange:NSMakeRange(1, 5)];
            //以"00:00"，作为字典的key。"ABCD"(数组的最后一位)作为字典的value
            NSDictionary *lyricDic = @{timeKey: [lyricAndTimeArr lastObject]};
            // 时间歌词的数组添加到时间歌词字典
            [self.timeForLyric addObject:lyricDic];
        }
    }
}


@end
