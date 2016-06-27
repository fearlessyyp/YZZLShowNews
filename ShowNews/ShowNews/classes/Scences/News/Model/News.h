//
//  News.h
//  ShowNews
//
//  Created by YYP on 16/6/27.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface News : NSObject
/// 详情页主key
@property (nonatomic, copy) NSString *postid;
/// 新闻标题
@property (nonatomic, copy) NSString *title;
/// 跳转处理id
@property (nonatomic, copy) NSString *skipID;
/// 跳转类型
@property (nonatomic, copy) NSString *skipType;
/// 图片地址
@property (nonatomic, copy) NSString *imgsrc;
/// 额外图片
@property (nonatomic, copy) NSArray *imgextra;
/// 新闻来源
@property (nonatomic, copy) NSString *source;



@end
