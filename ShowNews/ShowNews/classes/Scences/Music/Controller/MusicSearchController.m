//
//  MusicSearchController.m
//  ShowNews
//
//  Created by ZZQ on 16/6/24.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import "MusicSearchController.h"
#import <AFNetworking.h>
#import "NewsUrl.h"
@interface MusicSearchController ()<UITableViewDelegate, UITableViewDataSource>
/// 搜索栏
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
/// 搜索结果列表
@property (weak, nonatomic) IBOutlet UITableView *listResultTableView;

@end

@implementation MusicSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    NSLog(@"%@",NEWS_MUSIC_SEARCH_URL(周子琦, 雷坤, 岳云鹏));
    // Do any additional setup after loading the view from its nib.
    
}

#pragma mark - Table view data source
//  设置分区个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}
// 设置每个分区的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 0;
}

// 返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableView *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    VideoModel *model = self.allDataArray[indexPath.row];
//    [cell bindModel:model];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
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
