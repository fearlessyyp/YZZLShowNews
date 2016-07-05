//
//  UserViewController.h
//  ShowNews
//
//  Created by YYP on 16/6/25.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import "BaseViewController.h"
#import "MusicSearchController.h"
#import "VideoViewController.h"
@interface UserViewController : BaseViewController
@property (nonatomic, strong) MusicSearchController *musicSearchVC;
@property (nonatomic, strong) VideoViewController *videoVC;
@end
