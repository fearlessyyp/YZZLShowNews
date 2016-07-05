//
//  NewViewController.h
//  WXPlayer
//
//  Created by lanou3g on 16/6/15.
//  Copyright © 2016年 wxerters. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoViewController : BaseViewController
@property (nonatomic, strong)NSMutableArray *newMarray;
@property (nonatomic, strong)UITableView *privateTableView;
@property (nonatomic, assign) BOOL iscollect;
@end
