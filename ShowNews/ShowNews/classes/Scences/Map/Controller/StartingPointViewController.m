//
//  StartingPointViewController.m
//  ShowNews
//
//  Created by ZC on 16/7/6.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import "StartingPointViewController.h"
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件


#import "CPSViewController.h"
@interface StartingPointViewController ()<BNNaviRoutePlanDelegate,BMKGeoCodeSearchDelegate>
// 当前位置

@property (weak, nonatomic) IBOutlet UITextField *stopTF;
@property (nonatomic, strong)BMKGeoCodeSearch *searcher;
@property (nonatomic,strong) NSMutableArray *dataArray;


@end

@implementation StartingPointViewController
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        
    }
    return _dataArray;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  
       NSLog(@"%lf",self.coorfirst.latitude);
}

- (void)initWithSearcher {
    [self.stopTF resignFirstResponder];
    //初始化检索对象
    _searcher =[[BMKGeoCodeSearch alloc]init];
    _searcher.delegate = self;
    BMKGeoCodeSearchOption *geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
//    geoCodeSearchOption.city= @"北京市";
    geoCodeSearchOption.address = self.stopTF.text;
    BOOL flag = [_searcher geoCode:geoCodeSearchOption];
    if(flag)
    {
        NSLog(@"geo检索发送成功");
    }
    else
    {
        NSLog(@"geo检索发送失败");
    }
    
    }
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        self.coorEnd = CLLocationCoordinate2DMake(result.location.latitude, result.location.longitude);
        //检索成功后跳转
        [self pushNextController];
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}

- (IBAction)startSPSBtn:(id)sender {
    //检索写在这里
    [self initWithSearcher];
}
-(void)pushNextController {
    CPSViewController *gps = [[CPSViewController alloc]init];
    NSLog(@"%lf %lf",self.coorfirst.latitude,self.coorEnd.latitude);
    gps.startNode = self.coorfirst;
    gps.endNode = self.coorEnd;
    [self.navigationController pushViewController:gps animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backItemAction:)];
}

- (void)backItemAction:(UIBarButtonItem *)sender {
//    CPSViewController *gps = [[CPSViewController alloc]init];
    [self.navigationController popViewControllerAnimated:YES];
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
