//
//  SegmentView.h
//  ShowNews
//
//  Created by YYP on 16/4/11.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^TouchLabelIndexBlock)();

@protocol SegmentViewDelegate <NSObject>

- (void)touchLabelWithIndex:(NSInteger)index;

@end

@interface SegmentView : UIView
/**
 *  标题数组
 */
@property ( nonatomic, strong) NSArray *titleArray;

/**
 *  标题颜色
 */
@property ( nonatomic, strong) UIColor *titleColor;

/**
 *  标题被选中的颜色
 */
@property ( nonatomic, strong) UIColor *titleSelectedColor;

/**
 *  滚动条
 */
@property ( nonatomic, strong) UIView *scrollLine;

/**
 *  滚动条颜色
 */
@property ( nonatomic, strong) UIColor *scrollLineColor;

/**
 *  分割线颜色
 */
@property ( nonatomic, strong) UIColor *separateColor;

/**
 *  分割线
 */
@property ( nonatomic, strong) UIView *separateLine;

/**
 *  滚动条高度
 */
@property ( nonatomic, assign) float scrollLineHeight;

/**
 *  分割线高度
 */
@property ( nonatomic, assign) float separateHeight;

/**
 *  标题字体大小
 */
@property ( nonatomic, assign) CGFloat titleFont;



@property (nonatomic, weak) id<SegmentViewDelegate>touchDelegate;

//根据titleArray配置label
- (void)configSubLabel;

//选中指定位置label
- (void)selectLabelWithIndex:(NSInteger)index;


@end
