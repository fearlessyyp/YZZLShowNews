//
//  ForgetPasswordViewController.m
//  ShowNews
//
//  Created by YYP on 16/7/7.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import <MBProgressHUD.h>
#import <AVOSCloud/AVOSCloud.h>

typedef NS_ENUM(NSUInteger, TextFieldError) {
    TextFieldErrorNil,
    TextFieldErrorError,
    TextFieldErrorNoMatch,
    TextFieldErrorNormal,
};


@interface ForgetPasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *yanzhengCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *surePasTextField;

@property (weak, nonatomic) IBOutlet UIButton *codeButton;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, assign) int time;

@property (weak, nonatomic) IBOutlet UIButton *phoneButton;

@property (weak, nonatomic) IBOutlet UIButton *passwordButton;

@property (weak, nonatomic) IBOutlet UIButton *surePasButton;

@property (nonatomic, assign) TextFieldError phoneError;

@property (nonatomic, assign) TextFieldError passwordError;

@property (nonatomic, assign) TextFieldError surePasError;


@end

@implementation ForgetPasswordViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backItemAction:)];
}

- (void)backItemAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"找回密码";
    self.codeButton.userInteractionEnabled = NO;
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
    self.timeLabel.font = [UIFont systemFontOfSize:12.f];
    self.timeLabel.textColor = NEWS_MAIN_COLOR;
    
    [self.phoneNumTextField addTarget:self action:@selector(phoneTextFieldAction:) forControlEvents:UIControlEventEditingDidEnd];
    [self.passwordTextField addTarget:self action:@selector(passwordTextFieldAction:) forControlEvents:UIControlEventEditingDidEnd];
    [self.surePasTextField addTarget:self action:@selector(surePasswordTextFieldAction:) forControlEvents:UIControlEventEditingDidEnd];
}

#pragma mark - 电话号码输入框
- (void)phoneTextFieldAction:(UITextField *)sender {
    NSString*pattern =@"^1+[3578]+\\d{9}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    BOOL isMatch = [pred evaluateWithObject:self.phoneNumTextField.text];

    if (sender.text.length == 0) {
        [self setHUDWithTitle:@"请输入电话号码"];
        self.phoneError = TextFieldErrorNil;
    } else {
        if (isMatch) {
            NSString *cql = @"select * from _User where mobilePhoneNumber = ?";
            NSArray *pvalues =  @[self.phoneNumTextField.text];
            [AVQuery doCloudQueryInBackgroundWithCQL:cql pvalues:pvalues callback:^(AVCloudQueryResult *result, NSError *error) {
                if (!error) {
                    // 操作成功
                    if (result.results.count > 0) {
                        [self.phoneButton setImage:[[UIImage imageNamed:@"true"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
                        self.phoneError = TextFieldErrorNormal;
                        self.codeButton.userInteractionEnabled = YES;
                        self.codeButton.titleLabel.textColor = NEWS_MAIN_COLOR;
                        
                    } else {
                        [self.phoneButton setImage:[[UIImage imageNamed:@"error"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
                        self.phoneError = TextFieldErrorError;
                        [self setHUDWithTitle:@"该手机号未注册"];
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
#pragma mark - 密码输入框
- (void)passwordTextFieldAction:(UITextField *)sender {
    if (sender.text.length > 0) {
        [self.passwordButton setImage:[[UIImage imageNamed:@"true"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        self.passwordError = TextFieldErrorNormal;
    } else {
        [self setHUDWithTitle:@"请输入密码"];
        [self.passwordButton setImage:[[UIImage imageNamed:@"error"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [sender resignFirstResponder];
        self.passwordError = TextFieldErrorNil;
    }
}
#pragma mark - 确认密码输入框
- (void)surePasswordTextFieldAction:(UITextField *)sender {
    if (sender.text.length == 0) {
        [self setHUDWithTitle:@"请输入密码"];
        [self.passwordButton setImage:[[UIImage imageNamed:@"error"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        self.passwordError = TextFieldErrorNil;
        return;
    }
    if (![self.passwordTextField.text isEqualToString:sender.text]) {
        [self setHUDWithTitle:@"两次密码不一致"];
        [self.surePasButton setImage:[[UIImage imageNamed:@"error"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [sender resignFirstResponder];
        self.surePasError = TextFieldErrorError;
    } else {
        [self.surePasButton setImage:[[UIImage imageNamed:@"true"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        self.surePasError = TextFieldErrorNormal;
    }
}

- (IBAction)phoneButtonClick:(UIButton *)sender {
    switch (self.phoneError) {
        case TextFieldErrorNormal:
            break;
        case TextFieldErrorError:
            [self setHUDWithTitle:@"该手机号未注册"];
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

- (IBAction)passwordButtonClick:(UIButton *)sender {
    switch (self.passwordError) {
        case TextFieldErrorNil:
            [self setHUDWithTitle:@"请输入新密码"];
            break;
        case TextFieldErrorNormal:
            break;
        case TextFieldErrorError:
            break;
        default:
            break;
    }
}
- (IBAction)surePasButton:(UIButton *)sender {
    switch (self.surePasError) {
        case TextFieldErrorNil:
            [self setHUDWithTitle:@"请确认密码"];
            break;
        case TextFieldErrorNormal:
            break;
        case TextFieldErrorError:
            [self setHUDWithTitle:@"两次密码不一致,请重新输入"];
            break;
        default:
            break;
    }
}


#pragma mark - 完成按钮点击事件
- (IBAction)DoneAction:(UIButton *)sender {
    [self.view endEditing:YES];
    if (self.phoneError == TextFieldErrorNormal && self.passwordError == TextFieldErrorNormal && self.surePasError == TextFieldErrorNormal) {
        [AVUser resetPasswordWithSmsCode:self.yanzhengCodeTextField.text newPassword:self.passwordTextField.text block:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                
            } else {
                NSLog(@"^^^^^^^^^^^%@", error);
            }
        }];
    }
}
#pragma mark - 获取验证码按钮点击事件
- (IBAction)getCodeButtonAction:(UIButton *)sender {
    
    if (self.phoneNumTextField.text.length == 0) {
        [self setHUDWithTitle:@"请输入手机号"];
    } else {
        NSString*pattern =@"^1+[3578]+\\d{9}";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
        BOOL isMatch = [pred evaluateWithObject:self.phoneNumTextField.text];
        if (isMatch) {
            [AVUser requestPasswordResetWithPhoneNumber:self.phoneNumTextField.text block:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                     [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
                } else {
                    if (error.code == 601) {
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
