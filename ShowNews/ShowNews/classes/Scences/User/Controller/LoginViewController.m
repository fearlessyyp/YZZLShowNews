//
//  LoginViewController.m
//  ShowNews
//
//  Created by ZZQ on 16/7/2.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import "LoginViewController.h"
#import "AuthenticationViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import <MBProgressHUD.h>

@interface LoginViewController ()
/// 注册按钮
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"登录";
    self.userNameTextField.text = self.username;
}

#pragma mark - 验证页面
- (IBAction)registerButtonAction:(UIButton *)sender {
    AuthenticationViewController *authenticationVC = [[AuthenticationViewController alloc] init];
    [self.navigationController pushViewController:authenticationVC animated:YES];
}

#pragma mark - 登录按钮点击事件
- (IBAction)loginButtonAction:(id)sender {
    if (self.passwordTextField.text.length == 0) {
        [self setHUDWithTitle:@"请输入密码"];
        return;
    }
    if (self.userNameTextField.text.length == 0) {
        [self setHUDWithTitle:@"请输入用户名或手机号码"];
    }
    // 手机号密码登录
    // 不成功 - > 用户名密码登录
    [AVUser logInWithMobilePhoneNumberInBackground:self.userNameTextField.text password:self.passwordTextField.text block:^(AVUser *user, NSError *error) {
        if (user != nil) {
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [AVUser logInWithUsernameInBackground:self.userNameTextField.text password:self.passwordTextField.text block:^(AVUser *user, NSError *error) {
                if (user != nil) {
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    if (error.code == 201) {
                        [self setHUDWithTitle:@"用户名或密码错误"];
                    } else if (error.code == 211 || error.code == 213) {
                        [self setHUDWithTitle:@"用户名或手机号不存在"];
                    }
                }
            }];
        }
    }];
}
#pragma mark- 忘记密码点击事件
- (IBAction)forgetPasswordButtonAction:(id)sender {

}


- (void)setHUDWithTitle:(NSString *)title {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = title;
    hud.margin = 10.f;
    hud.yOffset = 0.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
}

@end
