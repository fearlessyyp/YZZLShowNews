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


typedef NS_ENUM(NSUInteger, TextFieldError) {
    TextFieldErrorNil,
    TextFieldErrorError,
    TextFieldErrorNoMatch,
    TextFieldErrorNormal,
};


@interface AuthenticationViewController ()
/// 电话号码
@property (weak, nonatomic) IBOutlet UITextField *phoneTextFiled;
/// 验证码code
@property (weak, nonatomic) IBOutlet UITextField *yanzhengCodeTextField;

@property (weak, nonatomic) IBOutlet UIButton *codeButton;

@property (nonatomic, assign) int time;

@property (nonatomic, strong) UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIButton *phoneButton;

@property (nonatomic, assign) TextFieldError phoneError;

@property (nonatomic, assign) TextFieldError codeError;

@end

@implementation AuthenticationViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backItemAction:)];
}

- (void)backItemAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"快速注册 - 验证手机";
    [self.phoneTextFiled becomeFirstResponder];
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
    self.timeLabel.font = [UIFont systemFontOfSize:12.f];
    self.timeLabel.textColor = NEWS_MAIN_COLOR;
    self.codeButton.userInteractionEnabled = NO;
    [self.phoneTextFiled addTarget:self action:@selector(phoneTextFieldAction:) forControlEvents:UIControlEventEditingDidEnd];
    [self.yanzhengCodeTextField addTarget:self action:@selector(codeTextFieldAction:) forControlEvents:UIControlEventEditingDidEnd];
}

#pragma mark - 电话号码输入框
- (void)phoneTextFieldAction:(UITextField *)sender {
    if (sender.text.length == 0) {
        [self setHUDWithTitle:@"请输入电话号码"];
        self.phoneError = TextFieldErrorNil;
    } else {
        NSString*pattern =@"^1+[3578]+\\d{9}";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
        BOOL isMatch = [pred evaluateWithObject:self.phoneTextFiled.text];
        if (isMatch) {
            NSString *cql = @"select * from _User where mobilePhoneNumber = ?";
            NSArray *pvalues =  @[self.phoneTextFiled.text];
            [AVQuery doCloudQueryInBackgroundWithCQL:cql pvalues:pvalues callback:^(AVCloudQueryResult *result, NSError *error) {
                if (!error) {
                    // 操作成功
                    if (result.results.count > 0) {
                        [self.phoneButton setImage:[[UIImage imageNamed:@"error"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
                        self.phoneError = TextFieldErrorError;
                        [self setHUDWithTitle:@"该手机号已被注册"];
                        
                    } else {
                        [self.phoneButton setImage:[[UIImage imageNamed:@"true"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
                        self.phoneError = TextFieldErrorNormal;
                        self.codeButton.userInteractionEnabled = YES;
                        self.codeButton.titleLabel.textColor = NEWS_MAIN_COLOR;
                    }
                } else {
                    NSLog(@"%@", error);
                }
            }];
            
        } else {
            [self.phoneButton setImage:[[UIImage imageNamed:@"error"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            self.phoneError = TextFieldErrorNoMatch;
            [self setHUDWithTitle:@"请输入正确的手机号码"];
            
        }
    }
}


- (IBAction)phoneButtonClick:(UIButton *)sender {
    switch (self.phoneError) {
        case TextFieldErrorNormal:
            break;
        case TextFieldErrorError:
            [self setHUDWithTitle:@"该手机号已被注册"];
            break;
        case TextFieldErrorNil:
            [self setHUDWithTitle:@"请输入手机号码"];
            break;
        case TextFieldErrorNoMatch:
            [self setHUDWithTitle:@"请输入正确的手机号码"];
        default:
            break;
    }
}


#pragma mark - 验证码
- (void)codeTextFieldAction:(UITextField *)textField {
    if (self.yanzhengCodeTextField.text.length == 0) {
        self.codeError = TextFieldErrorNil;
        [self setHUDWithTitle:@"请输入验证码"];
    } else {
        self.codeError = TextFieldErrorNormal;
    }
}

#pragma mark - 下一步按钮点击事件
- (IBAction)nextStepAction:(UIButton *)sender {
    [self.view endEditing:YES];
    if (self.phoneError == TextFieldErrorNormal && self.codeError == TextFieldErrorNormal) {
        [AVUser signUpOrLoginWithMobilePhoneNumberInBackground:self.phoneTextFiled.text smsCode:self.yanzhengCodeTextField.text block:^(AVUser *user, NSError *error) {
            // 如果 error 为空就可以表示登录成功了，并且 user 是一个全新的用户
            if (!error) {
            // 验证手机号码成功,注册了一个新的用户
                RegisterViewController *registerVC = [[RegisterViewController alloc] init];
                registerVC.phoneNum = self.phoneTextFiled.text;
                [self.navigationController pushViewController:registerVC animated:YES];
            }
        }];
    }
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
                if (!error) {
                    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
                } else {
                    if (error.code == 214) {
                        [self setHUDWithTitle:@"手机号码已经被注册"];
                    } else if (error.code == 601) {
                        [self setHUDWithTitle:@"发送验证码过于频繁"];
                    }
                }
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

- (void)timerAction:(NSTimer *)timer {
    self.codeButton.userInteractionEnabled = NO;
         [self.codeButton setTitle:@"" forState:UIControlStateNormal];
    if (self.time < 60) {
        if (self.time == 0) {
            [self.codeButton addSubview:self.timeLabel];
        }
        self.time++;
        self.timeLabel.text = [NSString stringWithFormat:@"%d秒后可以再次获取", 60 - self.time];
    } else if (self.time == 60) {
        self.codeButton.userInteractionEnabled = YES;
        [self.timeLabel removeFromSuperview];
        [self.codeButton setTitle:[NSString stringWithFormat:@"获取验证码"] forState:UIControlStateNormal];
        [timer invalidate];
    }
}

@end
