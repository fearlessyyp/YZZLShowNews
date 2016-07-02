//
//  collectCell.h
//  ShowNews
//
//  Created by ZZQ on 16/6/29.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^Block)(NSInteger);

@interface collectCell : UITableViewCell


@property (nonatomic, strong) Block block;

@property (weak, nonatomic) IBOutlet UIView *newsView;




@end
