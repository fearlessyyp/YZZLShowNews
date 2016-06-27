//
//  VideoView.h
//  ShowNews
//
//  Created by LK on 16/6/26.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^Request)();
@interface VideoView : UIView

@property (nonatomic, strong) UIImageView *myImageView;

@property (nonatomic, strong) UIButton *button;


@property (nonatomic, copy) Request request;

@end
