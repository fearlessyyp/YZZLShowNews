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
/// 其他新闻(轮播)
@property (nonatomic, strong) NSArray *ads;
#pragma mark - 新闻详情页数据
/// 详情页新闻体
@property (nonatomic, strong) NSString *body;
/// 详情页面图片标题数组
@property (nonatomic, strong) NSMutableArray *images;
/// 新闻发布时间
@property (nonatomic, strong) NSString *ptime;
/// 新闻分享连接
@property (nonatomic, strong) NSString *shareLink;
/// 摘要
@property (nonatomic, strong) NSString *digest;

@end
