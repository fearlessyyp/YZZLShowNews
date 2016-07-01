//
//  NewsImage.h
//  ShowNews
//
//  Created by YYP on 16/6/29.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsImage : NSObject
@property (nonatomic, copy) NSString *src;
/** 图片尺寸 */
@property (nonatomic, copy) NSString *pixel;
/** 图片所处的位置 */
@property (nonatomic, copy) NSString *ref;
/** 图片标题 */
@property (nonatomic, copy) NSString *alt;

#pragma mark - 图片组图片数据
/** 图片地址 */
@property (nonatomic, copy) NSString *imgurl;
/** 图片标题 */
@property (nonatomic, copy) NSString *imgtitle;
/** 图片详情 */
@property (nonatomic, copy) NSString *note;


+ (instancetype)detailImgWithDict:(NSDictionary *)dict;
@end
