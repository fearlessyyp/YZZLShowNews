//
//  NewsImage.m
//  ShowNews
//
//  Created by YYP on 16/6/29.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import "NewsImage.h"

@implementation NewsImage
/** 便利构造器方法 */
+ (instancetype)detailImgWithDict:(NSDictionary *)dict
{
    NewsImage *imgModel = [[self alloc]init];
    imgModel.ref = dict[@"ref"];
    imgModel.pixel = dict[@"pixel"];
    imgModel.src = dict[@"src"];
    imgModel.alt = dict[@"alt"];
    return imgModel;
}

#pragma mark - 防崩
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
