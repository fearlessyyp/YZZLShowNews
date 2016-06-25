//
//  NSString+TimeFormatter.h
//  UI项目MusicPlay
//
//  Created by lanou3g on 16/6/14.
//  Copyright © 2016年 雷坤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (TimeFormatter)


// 200 -> 03:20

+ (NSString *)getStringWithTime:(CGFloat)second;


// 03:20 -> 200
+ (CGFloat)getSecondWithString:(NSString *)string;

- (CGFloat)getSecondWithString;



@end
