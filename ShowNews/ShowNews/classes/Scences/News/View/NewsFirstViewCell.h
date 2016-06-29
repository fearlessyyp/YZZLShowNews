//
//  NewsFirstViewCell.h
//  ShowNews
//
//  Created by YYP on 16/6/28.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SMPageControl.h>
@interface NewsFirstViewCell : UITableViewCell
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) SMPageControl *pageControl;
@property (nonatomic, strong) UIImageView *myImageView;
@property (nonatomic, strong) NSMutableArray *imageArr;
@property (nonatomic, strong) UILabel *titleLabel;

- (void)addAllViews;
@end
