//
//  LoginViewController.m
//  ShowNews
//
//  Created by ZZQ on 16/7/2.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
/// 头像图片
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
/// 账户名
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
/// 密码
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
/// 账户名错误提示
@property (weak, nonatomic) IBOutlet UILabel *namePrompt;
/// 密码错误提示
@property (weak, nonatomic) IBOutlet UILabel *passwordPrompt;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.headImageView.layer.cornerRadius = 50;
    self.headImageView.layer.masksToBounds = YES;
}

// 登录按钮
- (IBAction)loginButton:(UIButton *)sender {
    
}

// 邮箱注册
- (IBAction)emailRegister:(UIButton *)sender {
    
}

// 手机号注册
- (IBAction)phoneRegisterAction:(id)sender {
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
