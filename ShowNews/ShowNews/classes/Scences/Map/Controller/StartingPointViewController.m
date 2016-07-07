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
@property (weak, nonatomic) IBOutlet UITextField *currentTF;
@property (weak, nonatomic) IBOutlet UITextField *stopTF;
@property (nonatomic, assign)CLLocationCoordinate2D coor;
@property (nonatomic, strong)BMKGeoCodeSearch *searcher;


@end

@implementation StartingPointViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  
    //初始化检索对象
    [self initWithSearcher];
}

- (void)initWithSearcher {
    //初始化检索对象
    _searcher =[[BMKGeoCodeSearch alloc]init];
    _searcher.delegate = self;
    BMKGeoCodeSearchOption *geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
//    geoCodeSearchOption.city= @"北京市";
    geoCodeSearchOption.address = self.currentTF.text;
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
        self.coor = CLLocationCoordinate2DMake(result.location.latitude, result.location.longitude);
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}

- (IBAction)startSPSBtn:(id)sender {
    CPSViewController *gps = [[CPSViewController alloc]init];
    gps.coor = CLLocationCoordinate2DMake(self.coorfirst, self.coorSecond);
    gps.coorFirst = self.coor;
    [self.navigationController pushViewController:gps animated:YES];
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
