//
//  SetCell.h
//  ShowNews
//
//  Created by ZZQ on 16/6/30.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UILabel+Font.h"
@interface SetCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIButton *cellButton;

@property (weak, nonatomic) IBOutlet UISwitch *cellSwitch;

@end
