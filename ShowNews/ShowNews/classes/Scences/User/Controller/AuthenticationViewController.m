//
//  AuthenticationViewController.m
//  ShowNews
//
//  Created by YYP on 16/7/5.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import "AuthenticationViewController.h"
#import "RegisterViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import <MBProgressHUD.h>

@interface AuthenticationViewController ()
/// 电话号码
@property (weak, nonatomic) IBOutlet UITextField *phoneTextFiled;
/// 验证码code
@property (weak, nonatomic) IBOutlet UITextField *yanzhengCodeTextField;

@end

@implementation AuthenticationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
#pragma mark - 下一步按钮点击事件
- (IBAction)nextStepAction:(UIButton *)sender {
//    if (self.yanzhengCodeTextField.text.length == 0) {
//        [self setHUDWithTitle:@"请输入验证码"];
//    } else {
//        [AVUser signUpOrLoginWithMobilePhoneNumberInBackground:self.phoneTextFiled.text smsCode:self.yanzhengCodeTextField.text block:^(AVUser *user, NSError *error) {
//            // 如果 error 为空就可以表示登录成功了，并且 user 是一个全新的用户
//            if (!error) {
                // 验证手机号码成功,注册了一个新的用户
                RegisterViewController *registerVC = [[RegisterViewController alloc] init];
                registerVC.phoneNum = self.phoneTextFiled.text;
                [self.navigationController pushViewController:registerVC animated:YES];
//            }
//        }];
//    }
    
}
#pragma mark - 获取验证码按钮点击事件
- (IBAction)getCodeButtonAction:(UIButton *)sender {
    
    if (self.phoneTextFiled.text.length == 0) {
        [self setHUDWithTitle:@"请输入手机号"];
    } else {
        NSString*pattern =@"^1+[3578]+\\d{9}";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
        BOOL isMatch = [pred evaluateWithObject:self.phoneTextFiled.text];
        if (isMatch) {
            [AVOSCloud requestSmsCodeWithPhoneNumber:self.phoneTextFiled.text callback:^(BOOL succeeded, NSError *error) {
                
            }];
        } else {
            [self setHUDWithTitle:@"请输入正确的手机号"];
        }
    }
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
