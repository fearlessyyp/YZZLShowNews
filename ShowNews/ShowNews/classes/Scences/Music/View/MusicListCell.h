//
//  MusicListCell.h
//  ShowNews
//
//  Created by ZZQ on 16/6/25.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Music;
@interface MusicListCell : UITableViewCell

- (void)bindModel:(Music *)model;

@end
