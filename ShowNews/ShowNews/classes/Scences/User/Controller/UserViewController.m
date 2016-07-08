//
//  UserViewController.m
//  ShowNews
//
//  Created by YYP on 16/6/25.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import "UserViewController.h"
#import "collectCell.h"
#import "UIScrollView+ScalableCover.h"
#import "UIImage+ImageByColor.h"
#import "NewsUrl.h"
#import "SetCell.h"
#import "NewsCollectViewController.h"
#import "UIImageView+WebCache.h"
#import "Simple.h"
#import <AVOSCloud/AVOSCloud.h>
#import "LoginViewController.h"
#import "VideoViewController.h"
#import "MusicSearchController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "Music.h"
#import "DataBaseHandle.h"
#import "PlayerManager.h"
#import "RESideMenu.h"
#import <MJRefresh.h>

@interface UserViewController ()<UITableViewDelegate, UITableViewDataSource>
// 提示清除缓存的文字
@property (nonatomic, copy) NSString *cacheStr;
// 缓存文件路径
@property (nonatomic, copy) NSString *path;
//
@property (weak, nonatomic) IBOutlet UITableView *userTableView;

@property (nonatomic, strong) UIView *moonView;

@property (nonatomic, strong) UIWindow *window;
// window 的第一个子视图
@property (nonatomic, strong) UIView *parentView;
// 夜间模式UISwitch
@property (nonatomic, strong) UISwitch *cellSwitch;
// 记录当前的亮度
@property (nonatomic, assign) float currentBrightness;
// 记录存放的收藏音乐 大数组
@property (nonatomic, strong) NSMutableArray *allCollectMusicArr;

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) NSString *username;

@end

@implementation UserViewController

- (NSMutableArray *)allCollectMusicArr {
    if (!_allCollectMusicArr) {
        _allCollectMusicArr = [NSMutableArray array];
    }
    return _allCollectMusicArr;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
  
    
    
    NSData *data = [[AVUser currentUser] objectForKey:@"headImage"];
    if (data) {
        self.image = [UIImage imageWithData:data];
        self.username = [AVUser currentUser].username;
    } else {
        self.image = [UIImage imageNamed:@"comment_profile_default"];
        self.username = @"登录";
    }
    self.userTableView.bigImage.image = self.image;
    [self.userTableView.button setTitle:self.username forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    // 记录当前的亮度
    _currentBrightness = [UIScreen mainScreen].brightness;
    
    [self.userTableView registerNib:[UINib nibWithNibName:@"SetCell" bundle:nil] forCellReuseIdentifier:@"SetImage"];
    [self.userTableView registerNib:[UINib nibWithNibName:@"SetCell" bundle:nil] forCellReuseIdentifier:@"SetSwitch"];
    // 头视图
    [self headForTableView];
    
    // 添加监听
    [_userTableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    // 隐藏nav的线
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
}

// 头视图 类目 三方
- (void)headForTableView {
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageWithColor:NEWS_MAIN_COLOR]];
    UIButton *button = [self.userTableView addScalableCoverWithImage:image.image headImage:self.image];
    [button setTitle:self.username forState:UIControlStateNormal];
    [button addTarget:self action:@selector(loginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
#warning 200 -> 150
    self.userTableView.tableHeaderView = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, self.userTableView.frame.size.width, 150)];
}

// 登录按钮点击事件
- (void)loginButtonClick:(UIButton *)button {
    // 判断,如果有用户登录,就显示用户名,没有就显示登录
    if ([AVUser currentUser] == nil) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        loginVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0: {
            static NSString *collectCellID = @"collectCellID";
            collectCell *cell1 = [tableView dequeueReusableCellWithIdentifier:collectCellID];
            if (!cell1) {
                // 在xib  Cell 里添加了点击事件
                // 返回的nib文件里(响应)的对象
                NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"collectCell" owner:nil options:nil];
                // 队列顺序
                cell1 = [arr firstObject];
                
                cell1.block = ^(NSInteger num){
                    
                    switch (num) {
                        case 1:{
                            if ([AVUser currentUser]) {
                                NewsCollectViewController * newsCollectVC = [[NewsCollectViewController alloc] init];
                                [self.navigationController pushViewController:newsCollectVC animated:YES];
                            } else {
                                LoginViewController *loginVC = [[LoginViewController alloc] init];
                                [self.navigationController pushViewController:loginVC animated:YES];
                            }
                        }
                            break;
                        case 2:{
                            if ([AVUser currentUser]) {
                                VideoViewController *videoVC = [[VideoViewController alloc] init];
                                videoVC.iscollect = YES;
                                [self requestData:videoVC];
                                videoVC.isUser = YES;
                                [self.navigationController pushViewController:videoVC animated:YES];
                            } else {
                                LoginViewController *loginVC = [[LoginViewController alloc] init];
                                
                                [self.navigationController pushViewController:loginVC animated:YES];
                            }
                            
                        }
                            break;
                        case 3:
                            
                            break;
                        case 4:{
                            if ([AVUser currentUser]) {
                                [[PlayerManager sharePlayer] requestData:self.musicSearchVC];
                                [self presentRightMenuViewController:self.musicSearchVC];
                            } else {
                                LoginViewController *loginVC = [[LoginViewController alloc] init];
                                [self.navigationController pushViewController:loginVC animated:YES];
                            }
                        }
                            break;
                            
                        default:
                            break;
                    }
                };
            }
            return cell1;
            break;
        }
        case 1:{
            SetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SetImage" forIndexPath:indexPath];
            cell.nameLabel.text = @"清除缓存";
//            cell.cellLabel.text = _cacheStr;
            [cell.cellSwitch removeFromSuperview];
            return cell;
            break;
        }
        case 2: {
            SetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SetSwitch" forIndexPath:indexPath];
            cell.nameLabel.text = @"夜间模式";
            [cell.cellSwitch setOn:NO];
            [cell.cellSwitch addTarget:self action:@selector(openChange:) forControlEvents:UIControlEventValueChanged];
            
            return cell;
            break;
        }
        case 3: {
#warning 还得注册个CELL 不能添加SWITCH  会重复添加
            SetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SetSwitch" forIndexPath:indexPath];
            cell.nameLabel.text = @"仅WIFI播放视频";

            [cell.cellSwitch addTarget:self action:@selector(isWifiChange:) forControlEvents:UIControlEventValueChanged];
            
            return cell;
            break;
        }
        case 4: {
            SetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SetImage" forIndexPath:indexPath];
            cell.nameLabel.text = @"版本号";
            cell.cellLabel.text = @"1.0.0";
            [cell.cellSwitch removeFromSuperview];
            return cell;
            break;
        }
        case 5: {
            SetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SetImage" forIndexPath:indexPath];
            cell.nameLabel.text = @"免责声明";
            [cell.cellSwitch removeFromSuperview];
            return cell;
            break;
        }
        case 6: {
            SetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SetImage" forIndexPath:indexPath];
            cell.nameLabel.text = @"注销";
            [cell.cellSwitch removeFromSuperview];
            return cell;
            break;
        }
        default:
            break;
    }
    return nil;
}

- (void)isWifiChange:(UISwitch *)sender
{
    [DataBaseHandle sharedDataBaseHandle].isWifi = sender.isOn;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView cellForRowAtIndexPath:indexPath].selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.row) {
        case 1:{
            
          
            // 缓存文件路径
            NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            float size = [UserViewController folderSizeAtPath:path];
            _cacheStr = [NSString stringWithFormat:@"%.2fM", size];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"缓存大小为%@,确定要清除吗?", _cacheStr] preferredStyle:UIAlertControllerStyleAlert];
            
            
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [UserViewController clearCache:_path];
                _cacheStr = [NSString stringWithFormat:@"0.00M"];
//                SetCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//                cell.cellLabel.text = _cacheStr;
            }];
            
            UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:sureAction];
            [alert addAction:cancleAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
            
            break;
        case 2:
            
            break;
        case 3:
            
            break;
        case 4:
            
            break;
        case 5:
            
            break;
        case 6:
            [AVUser logOut];
            self.image = [UIImage imageNamed:@"comment_profile_default"];
            self.username = @"登录";
            self.userTableView.bigImage.image = self.image;
            [self.userTableView.button setTitle:self.username forState:UIControlStateNormal];
            break;
            break;
           
            
        default:
            break;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 80;
    }else {
        return 40;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kScreenSizeWidth, 30)];
        headLabel.text = @"      收藏";
        headLabel.font = [UIFont systemFontOfSize:14.f];
        return headLabel;//
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

// 监听 table滑动Y值
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
#warning 136 -> 136 - 50
    if (_userTableView.contentOffset.y < 136 - 50) {
        self.navigationItem.leftBarButtonItem = nil;
    } else {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 42, 42)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 50, 44)];
        // 判断,如果有用户登录,就显示用户名,没有就显示登录
        if ([AVUser currentUser] != nil) {
            label.text = [AVUser currentUser].username;
        } else {
            label.text = nil;
        }
        image.image = self.image;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:12];
        image.layer.cornerRadius= 21;
        image.layer.masksToBounds = YES;
        [view addSubview:image];
        [view addSubview:label];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    }
}

// 计算单个文件大小
+(float)fileSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size/1024.0/1024.0;
    }
    return 0;
}

// 计算目录大小
+(float)folderSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    float folderSize;
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            folderSize +=[UserViewController fileSizeAtPath:absolutePath];
        }
        //SDWebImage框架自身计算缓存的实现
        folderSize+=[[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
        return folderSize;
    }
    return 0;
}

// 清理缓存文件
+(void)clearCache:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    [[SDImageCache sharedImageCache] cleanDisk];
}


- (void)openChange:(UISwitch *)sender {
    if (sender.isOn == YES) {
        [[UIScreen mainScreen] setBrightness:0.2];
        [Simple sharedSimple].moon = 1;
    }else{
        [[UIScreen mainScreen] setBrightness:_currentBrightness];
        [Simple sharedSimple].moon = 0;
    }
}


- (void)requestData:(VideoViewController *)searchVC {
    NSString *cql = [NSString stringWithFormat:@"select * from %@ where username = ?", @"VideoModel"];
    NSArray *pvalues =  @[[AVUser currentUser].username];
    [self.allCollectMusicArr removeAllObjects];
    [AVQuery doCloudQueryInBackgroundWithCQL:cql pvalues:pvalues callback:^(AVCloudQueryResult *result, NSError *error) {
        if (!error) {
            // 操作成功
            for (AVObject *obj in result.results) {
                VideoModel *videoModel = [[DataBaseHandle sharedDataBaseHandle] aVObjectToVideoModel:obj];
                [self.allCollectMusicArr addObject:videoModel];
            }
        } else {
            NSLog(@"%@", error);
        }
        searchVC.newMarray = self.allCollectMusicArr;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [searchVC.privateTableView reloadData];
            
        });
    }];
    
    
}



@end
