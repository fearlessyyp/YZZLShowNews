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

@interface UserViewController ()<UITableViewDelegate, UITableViewDataSource>

//
@property (weak, nonatomic) IBOutlet UITableView *userTableView;

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.translucent = NO;
    
    [self.userTableView registerNib:[UINib nibWithNibName:@"collectCell" bundle:nil] forCellReuseIdentifier:@"collect"];
    [self.userTableView registerNib:[UINib nibWithNibName:@"SetCell" bundle:nil] forCellReuseIdentifier:@"Set"];
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
    
   
    
    UIButton *button = [self.userTableView addScalableCoverWithImage:image.image URLStr:@"http://imgcache.qq.com/music/photo/mid_album_90/8/V/002iWU6B2ZvA8V.jpg"];
    
    [button setTitle:@"小丸子" forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.userTableView.tableHeaderView = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, self.userTableView.frame.size.width, 200)];
}

// 登录按钮点击事件
- (void)loginButtonClick {
    NSLog(@"跳转到登录页面");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     SetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Set" forIndexPath:indexPath];
    switch (indexPath.row) {
        case 0:{
            collectCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"collect" forIndexPath:indexPath];
            cell1.backgroundColor = [UIColor yellowColor];
            return cell1;
        }
            break;
        case 1:
           
            cell.nameLabel.text = @"字号设置";
            return cell;
            break;
        case 2:
            cell.nameLabel.text = @"清除缓存";
            return cell;
            break;
        case 3:
            cell.nameLabel.text = @"夜间模式";
            return cell;
            break;
        case 4:
            cell.nameLabel.text = @"仅WIFI播放视频";
            return cell;
            break;
        case 5:
            cell.nameLabel.text = @"版本号 : 1.0.0";
            return cell;
        
            break;
        default:
            break;
    }
    
 
        
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 90;
    }else {
        return 40;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kScreenSizeWidth, 30)];
        headLabel.text = @"     收藏";
        return headLabel;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

// 监听 table滑动Y值
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (_userTableView.contentOffset.y < 136) {
        self.navigationItem.leftBarButtonItem = nil;
//        [self.navigationController.navigationBar setHidden:YES];
    } else {
//        [self.navigationController.navigationBar setHidden:NO];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 42, 42)];
        image.image = [UIImage imageNamed:@"p1156430977.jpg"];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 50, 44)];
        label.text = @"小丸子";
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:12];
        
        image.layer.cornerRadius= 21;
        image.layer.masksToBounds = YES;
        [view addSubview:image];
        [view addSubview:label];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    }
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
