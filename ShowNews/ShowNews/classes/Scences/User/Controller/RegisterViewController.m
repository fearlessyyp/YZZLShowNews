//
//  RegisterViewController.m
//  ShowNews
//
//  Created by LK on 16/7/2.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import "RegisterViewController.h"
#import <MBProgressHUD.h>
#import <AVOSCloud/AVOSCloud.h>
#import "LoginViewController.h"

typedef NS_ENUM(NSUInteger, TextFieldError) {
    TextFieldErrorNil,
    TextFieldErrorError,
    TextFieldErrorNormal,
};

@interface RegisterViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
/// 图片
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (nonatomic, strong) UIImagePickerController *imagePicker; //图片选择器

// / 昵称的textField
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

/// 密码的TextField
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

/// 确认密码的textField
@property (weak, nonatomic) IBOutlet UITextField *surePasswordTextField;

@property (weak, nonatomic) IBOutlet UIButton *nameButton;

@property (weak, nonatomic) IBOutlet UIButton *passwordButton;

@property (weak, nonatomic) IBOutlet UIButton *surePasButton;

@property (nonatomic, assign) TextFieldError nameError;

@property (nonatomic, assign) TextFieldError passwordError;

@property (nonatomic, assign) TextFieldError surePasError;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"快速注册 - 完善资料";
    [self.nameTextField becomeFirstResponder];
    self.headImageView.userInteractionEnabled = YES;
    self.headImageView.layer.cornerRadius = kScreenSizeWidth * 0.15f;
    self.headImageView.layer.masksToBounds = YES;
    self.imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.delegate = self;
    
    [self.nameTextField addTarget:self action:@selector(nameTextFieldAction:) forControlEvents:UIControlEventEditingDidEnd];
    [self.passwordTextField addTarget:self action:@selector(passwordTextFieldAction:) forControlEvents:UIControlEventEditingDidEnd];
    [self.surePasswordTextField addTarget:self action:@selector(surePasswordTextFieldAction:) forControlEvents:UIControlEventEditingDidEnd];
    
}

#pragma mark - 昵称输入框
- (void)nameTextFieldAction:(UITextField *)sender {
    if (sender.text.length == 0) {
        [self setHUDWithTitle:@"请输入昵称"];
        self.nameError = TextFieldErrorNil;
    } else {
        NSString *cql = @"select * from _User where username = ?";
        NSArray *pvalues =  @[self.nameTextField.text];
        [AVQuery doCloudQueryInBackgroundWithCQL:cql pvalues:pvalues callback:^(AVCloudQueryResult *result, NSError *error) {
            if (!error) {
                // 操作成功
                if (result.results.count > 0) {
                    [self.nameButton setImage:[[UIImage imageNamed:@"error"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
                    self.nameError = TextFieldErrorError;
                } else {
                    [self.nameButton setImage:[[UIImage imageNamed:@"true"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
                    self.nameError = TextFieldErrorNormal;
                }
            } else {
                NSLog(@"%@", error);
                
            }
        }];
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

// 点击头像的方法
- (IBAction)tapGestureAction:(id)sender {
    // 调用系统相册、相机
    // 添加alertSheet
    __weak typeof(self)weakSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _imagePicker.allowsEditing = YES;
        [weakSelf presentViewController:_imagePicker animated:YES completion:nil];
    }];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        _imagePicker.allowsEditing = YES;
        [weakSelf presentViewController:_imagePicker animated:YES completion:nil];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:photoAction];
    [alert addAction:cameraAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)nameButtonClick:(UIButton *)sender {
    switch (self.nameError) {
        case TextFieldErrorNormal:
            break;
        case TextFieldErrorError:
            [self setHUDWithTitle:@"该昵称已被占用"];
            break;
        case TextFieldErrorNil:
            [self setHUDWithTitle:@"请输入昵称"];
            break;
        default:
            break;
    }
}

- (IBAction)passwordButtonClick:(UIButton *)sender {
    switch (self.passwordError) {
        case TextFieldErrorNil:
            [self setHUDWithTitle:@"请输入密码"];
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

#pragma mark - 注册账号
- (IBAction)registerButtonAction:(id)sender {
    [self.view endEditing:YES];
    if (self.nameError == TextFieldErrorNormal && self.passwordError == TextFieldErrorNormal && self.surePasError == TextFieldErrorNormal) {
        // 注册账号
        [[AVUser currentUser] setObject:self.nameTextField.text forKey:@"username"];
        [[AVUser currentUser] setObject:self.passwordTextField.text forKey:@"password"];
        NSData *data = UIImageJPEGRepresentation(self.headImageView.image,1.0);
        [[AVUser currentUser] setObject:data forKeyedSubscript:@"headImage"];
        [[AVUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                LoginViewController *loginVC = self.navigationController.viewControllers[1];
            
                loginVC.username = [AVUser currentUser].username;
                [AVUser logOut];  //清除缓存用户对象
                  [self.navigationController popToViewController:loginVC animated:YES];
            }
        }];
    } else {
        [self setHUDWithTitle:@"请完善以上信息"];
    }
    
    
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    // 赋值头像
    self.headImageView.image = image;
    
    // 如果是相机
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(saveImage), nil);
    }
    // dismiss当前的选择页面
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)saveImage {
#warning 存储图片??????
}

// 触摸空白区回收键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - UITextFeld Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    //键盘回收
    return [textField resignFirstResponder];
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
