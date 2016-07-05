//
//  AuthenticationViewController.m
//  ShowNews
//
//  Created by YYP on 16/7/5.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import "AuthenticationViewController.h"
#import "RegisterViewController.h"

@interface AuthenticationViewController ()

@end

@implementation AuthenticationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
#pragma mark -
- (IBAction)nextStepAction:(UIButton *)sender {
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

@end
