//
//  VideoTableViewController.m
//  ShowNews
//
//  Created by LK on 16/6/24.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import "VideoTableViewController.h"
#import "VideoCell.h"
#import <AFNetworking.h>
#import <AFNetworkActivityIndicatorManager.h>
#import "NewsUrl.h"
#import "VideoModel.h"
@interface VideoTableViewController ()
// / 存储数据的数组
@property (nonatomic, strong) NSMutableArray *allDataArray;

// / 用于网络请求的session对象
@property (nonatomic, strong) AFHTTPSessionManager *session;

@end

@implementation VideoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 单例 初始化session对象
    self.session = [AFHTTPSessionManager manager];
    // 解析数据
    [self readData];
    // 设置请求返回支持的文件类型
    self.session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"application/x-json",@"text/html", nil];
    
         // 转圈圈的菊花默认是关闭的，需要手动打开，在网络慢的情况下请求数据时，手机左上角就会出现转圈圈的菊花
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"VideoCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
}

// 懒加载数组
- (NSMutableArray *)allDataArray
{
    if (!_allDataArray) {
        _allDataArray = [NSMutableArray array];
    }
    return _allDataArray;
}


// 解析数据
- (void)readData
{
    __weak typeof (self)weakSelf = self;
    
    [self.session GET:NEWS_VIDEO_LIST_URL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"下载的进度");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 请求数据
        NSLog(@"请求成功");
        
        // 处理数据...
        NSArray *reusltArr = responseObject[@"V9LG4B3A0"];
       
        for (NSDictionary *dict in reusltArr) {
            VideoModel *videoModel = [[VideoModel alloc] init];
            [videoModel setValuesForKeysWithDictionary:dict];
            [weakSelf.allDataArray addObject:videoModel];
        }
        
        NSLog(@"%@", weakSelf.allDataArray);
        
        NSLog(@"请求成功%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败%@", error);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
//  设置分区个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}
// 设置每个分区的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.allDataArray.count;
}

// 返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     VideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    VideoModel *model = self.allDataArray[indexPath.row];
    [cell bindModel:model];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
