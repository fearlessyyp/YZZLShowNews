//
//  ToolForTextHeight.m
//  ShowNews
//
//  Created by YYP on 16/4/21.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import "ToolForHeight.h"

@implementation ToolForHeight
// 计算文本高度
+ (CGFloat)textHeightWithText:(NSString *)text
                        font:(UIFont *)font
                        width:(CGFloat)width{
    // iOS7.0之后求文本高度的方法，返回一个CGRect的高度
    // 第一个参数：文本的宽度（看设置的Label的宽度），高为10000的范围
    CGSize size = CGSizeMake(width, 10000);
    // 第二个参数：设置以行高为单位
    // 第三个参数：将字体和大小传过去
    CGRect rect = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil];
    
    return rect.size.height;
}


// 计算imageView的高度
+ (CGFloat)imageHeightWithImage:(UIImage *)image {
    // 按比例进行缩放
    // 得到原有图片的宽和高
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    // 安全判断
    if (width == 0) {
        return 0;
    }
    // 已知imageView的宽，求高度
    return height / width * [UIScreen mainScreen].bounds.size.width;
}
@end
