//
//  RootViewController.m
//  ShowNews
//
//  Created by YYP on 16/6/25.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import "RootViewController.h"
#import <Masonry.h>

// 图标的尺寸
#define kIconSize CGSizeMake(16, 16)

@interface RootViewController ()
@property (nonatomic, strong) UIView *myView;
@end

@implementation RootViewController

- (instancetype)init {
    if (self = [super init]) {
//        []
        [self initLayout];
    }
    return self;
}

- (void)viewDidLoad {
}

- (void)initLayout {
    
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.myView];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
