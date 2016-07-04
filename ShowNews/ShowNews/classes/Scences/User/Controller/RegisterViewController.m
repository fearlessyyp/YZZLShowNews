//
//  RegisterViewController.m
//  ShowNews
//
//  Created by LK on 16/7/2.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
// / 图片
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (nonatomic, strong) UIImagePickerController *imagePicker; //图片选择器

// / 电话的TextField
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
// / 电话的Lable
@property (weak, nonatomic) IBOutlet UILabel *phoneLable;
// / 验证的TextField
@property (weak, nonatomic) IBOutlet UITextField *testingTextField;

// / 验证的Lable
@property (weak, nonatomic) IBOutlet UILabel *testingLable;
// / 昵称的textField
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
// / 昵称的Label
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
// / 密码的TextField

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
// / 密码的Lable
@property (weak, nonatomic) IBOutlet UILabel *passwordLable;
// / 确认密码的textField
@property (weak, nonatomic) IBOutlet UITextField *surePasswordTextField;
// / 确认密码的Lable
@property (weak, nonatomic) IBOutlet UILabel *surePasswordLable;


@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"注册";
    self.imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.delegate = self;
    
}

// 点击头像的方法
- (IBAction)tapGestureAction:(id)sender {
    
    // 调用系统相机 相册
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"图库" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       // 相册
        _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;// 图库
        _imagePicker.allowsEditing = YES;
        [self presentViewController:_imagePicker animated:YES completion:nil];
    }];
    UIAlertAction *cinemaAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //相机
        _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;//相机
        _imagePicker.allowsEditing = YES;
        [self presentViewController:_imagePicker animated:YES completion:nil];
        [alert addAction:photoAction];
        [alert addAction:cinemaAction];
    }];
}

#pragma mark - 注册账号
- (IBAction)registerButtonAction:(id)sender {
    
    
    
    
    
    
    
    
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
