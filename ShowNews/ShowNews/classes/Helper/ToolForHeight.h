//
//  ToolForTextHeight.h
//  ShowNews
//
//  Created by YYP on 16/4/21.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import <Foundation/Foundation.h>
// 先引入UIKit框架
#import <UIKit/UIKit.h>

@interface ToolForHeight : NSObject
// 声明类方法，计算文本高度
+ (CGFloat)textHeightWithText:(NSString *)text
                         font:(UIFont *)font
                        width:(CGFloat)width;

// 计算图片高度
+ (CGFloat)imageHeightWithImage:(UIImage *)image;
@end
