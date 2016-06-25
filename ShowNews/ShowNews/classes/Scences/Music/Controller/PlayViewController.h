//
//  PlayViewController.h
//  UIpdd_test___音乐播放器
//
//  Created by ZZQ on 16/5/28.
//  Copyright © 2016年 ZZQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayViewController : UIViewController

@property (nonatomic,assign) NSUInteger musicIndex;

+ (PlayViewController *)sharePlayView;

@end
