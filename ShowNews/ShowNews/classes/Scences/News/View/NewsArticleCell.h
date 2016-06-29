//
//  NewsArticleCell.h
//  ShowNews
//
//  Created by ZZQ on 16/6/24.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "News.h"

@interface NewsArticleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
- (void)bindData:(News *)news;
@end
