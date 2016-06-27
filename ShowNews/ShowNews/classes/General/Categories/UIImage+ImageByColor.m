//
//  UIImage+ImageByColor.m
//  DouBan
//
//  Created by lanou3g on 16/6/16.
//  Copyright © 2016年 yyp. All rights reserved.
//

#import "UIImage+ImageByColor.h"

@implementation UIImage (ImageByColor)
#pragma mark - 用颜色生成图片
+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    // 绘制图片
    // 参数1：size - 新创建的位图上下文的大小（后面生成的图片image的大小）
    // 参数2：opaque - 设置不透明 NO：透明，Alpha通道开启  YES：不透明,Alpha通道关闭
    // 参数3：scale - 缩放因子
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    // 设置填充颜色
    [color setFill];
    // 填充矩形
    UIRectFill(rect);
    // 生成image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 结束
    UIGraphicsEndImageContext();
    return image;

}


@end
