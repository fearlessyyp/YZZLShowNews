//
//  LoginViewController.m
//  ShowNews
//
//  Created by ZZQ on 16/7/2.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import "LoginViewController.h"
#import "AuthenticationViewController.h"

@interface LoginViewController ()
/// 注册按钮
@property (weak, nonatomic) IBOutlet UIButton *registerButton;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"登录";
}

#pragma mark - 验证页面
- (IBAction)registerButtonAction:(UIButton *)sender {
    AuthenticationViewController *authenticationVC = [[AuthenticationViewController alloc] init];
    [self.navigationController pushViewController:authenticationVC animated:YES];
}


@end
