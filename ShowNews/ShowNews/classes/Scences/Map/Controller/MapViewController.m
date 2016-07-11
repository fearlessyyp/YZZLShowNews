//
//  MapViewController.m
//  ShowNews
//
//  Created by YYP on 16/6/25.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import "MapViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

#import "StartingPointViewController.h"
#import "CPSViewController.h"

@interface MapViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKPoiSearchDelegate>
@property (strong,nonatomic) BMKMapView *mapView;
@property (strong,nonatomic) BMKLocationService *locService;
@property (nonatomic, strong)BMKGeoCodeSearchOption *geoCodeSearchOption;
@property (nonatomic, strong) BMKPoiSearch *searcher_POI;
@property (nonatomic, strong)BMKGeoCodeSearch *searcher;
@property (nonatomic, strong)BMKPointAnnotation *annotation;
#pragma mark --- 记录定位的当前地点
@property (nonatomic, assign)CLLocationCoordinate2D coor;
@property(nonatomic,weak)UITextField * tf;
@property (nonatomic, strong) UITextField *addresssTextField;
@end

@implementation MapViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
     _searcher_POI.delegate = self;
    _searcher.delegate = self;
    _locService.delegate = self;
    }
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _searcher.delegate = nil;      // 不使用时, 至nil
    _searcher_POI.delegate = nil;
    _locService.delegate = nil;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 50, kScreenSizeWidth, kScreenSizeHeight - kNavigationAndStatusHeight)];
    [self.view addSubview:self.mapView];
    _locService = [[BMKLocationService alloc]init];
#pragma mark -- 初始化并设置地图缩放比例
    _searcher_POI = [[BMKPoiSearch alloc]init];
    self.mapView.zoomLevel = 17;
    //初始化BMKLocationService
    NSLog(@"进入普通定位态");
    [_locService startUserLocationService];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showIndoorMapPoi = YES;
    _mapView.showMapScaleBar = YES;
    _mapView.showMapPoi = YES;
    _mapView.showsUserLocation = YES;//显示定位图层
    
#pragma mark 初始化检索对象
    [self initWithSearcher];
    
//#pragma mark 路况
//    UIBarButtonItem *traffic = [[UIBarButtonItem alloc] initWithTitle:@"路况" style:(UIBarButtonItemStylePlain) target:self action:@selector(openTrafficAction:)];
//    self.navigationItem.rightBarButtonItem = traffic;
//    
//    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithTitle:@"导航" style:UIBarButtonItemStylePlain target:self action:@selector(startNavi)];
//    self.navigationItem.leftBarButtonItem = left;
    [self search];
}
- (void)search {
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
    imageView.image = [UIImage imageNamed:@"zhoubian"];
    [self.view addSubview:imageView];
    
    
    UITextField * tf = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 10, 10, kScreenSizeWidth - CGRectGetMaxX(imageView.frame) - 50, 30)];
    tf.placeholder = @"在附近搜索...";

    tf.borderStyle = UITextBorderStyleRoundedRect;
    tf.layer.borderColor = [UIColor grayColor].CGColor;
    tf.font = [UIFont systemFontOfSize:14.f];
    self.tf= tf;
    tf.backgroundColor = [UIColor colorWithRed:235 green:235 blue:241 alpha:1];
    [self.view addSubview:tf];
    
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeSystem];
    searchButton.frame = CGRectMake(CGRectGetMaxX(tf.frame) + 5, 10, 30, 30);
    [searchButton setBackgroundImage:[UIImage imageNamed:@"musicSearch"] forState:UIControlStateNormal];

    [searchButton addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchButton];
  
}
- (void)btnClick
{
#pragma mark -- 释放第一相应者
    [self.tf resignFirstResponder];
    if (self.tf == nil) {
        return;
        
        }
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
    option.pageIndex = 0;
    option.pageCapacity = 10;
#pragma mark -- 搜索当前的位置
    option.location = self.coor;
    //option.keyword = @"小吃";
    option.keyword = self.tf.text;
    option.pageIndex = 0;
    option.pageCapacity = 10;
    BOOL flag = [_searcher_POI poiSearchNearBy:option];
    
    if(flag)
    {
        NSLog(@"周边检索发送成功");
    }
    else
    {
        NSLog(@"周边检索发送失败");
    }

}
//发起导航
- (void)startNavi
{
    StartingPointViewController *starting = [[StartingPointViewController alloc]init];
    starting.coorfirst = self.coor;
    starting.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:starting animated:YES];
}
-(void)buttonAction:(UIButton *)sender {
    [self initWithSearcher];
    
}
#pragma mark - 初始化检索对象
- (void)initWithSearcher
{
    // 初始化检索对象
    _searcher =[[BMKGeoCodeSearch alloc]init];
    _searcher.delegate = self;
    BMKGeoCodeSearchOption *geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
//    geoCodeSearchOption.city= @"北京市";
//    geoCodeSearchOption.address = @"海淀区清河中街";
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

static BOOL isOpen = NO;
- (void)openTrafficAction:(id)sender {
    // 路况的打开关闭
    if (!isOpen) {
        [_mapView setTrafficEnabled:YES];
        isOpen = YES;
    }else {
        [_mapView setTrafficEnabled:NO];
        isOpen = NO;
    }
}


//实现Deleage处理回调结果
//接收正向编码结果
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        
        // 将上一次的大头针数据清空
        NSArray *array = [NSArray arrayWithArray:_mapView.annotations];
        [_mapView removeAnnotations:array];
        
        // 将上一次添加的覆盖视图清空
        array = [NSArray arrayWithArray:_mapView.overlays];
        [_mapView removeOverlays:array];
        
        // 添加大头针
        // 添加一个PointAnnotation
        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
       
        annotation.coordinate = result.location;
        //annotation.title = @"金五星";
        [_mapView addAnnotation:annotation];
        
        // 设置地图中心
        _mapView.centerCoordinate = result.location;
        // 添加覆盖视图
        // 周边检索
        
        //初始化检索对象
        _searcher_POI =[[BMKPoiSearch alloc]init];
        _searcher_POI.delegate = self;
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}

- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResultList errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        NSArray *poiInfoList = poiResultList.poiInfoList;
        // 将上一次的大头针数据清空
        NSArray *array1 = [NSArray arrayWithArray:_mapView.annotations];
        [_mapView removeAnnotations:array1];
        
        // 将上一次添加的覆盖视图清空
        array1 = [NSArray arrayWithArray:_mapView.overlays];
        [_mapView removeOverlays:array1];

        [poiInfoList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BMKPoiInfo *info = obj;
            NSLog(@"name = %@, address = %@", info.name , info.address );
                       // 添加大头针
            BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
            annotation.coordinate = info.pt;
            annotation.title = info.name;
            [_mapView addAnnotation:annotation];
            
            

            
        }];
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调议建检索城市列表
        // result.cityList;
        NSLog(@"起始点有歧义");
    } else {
        NSLog(@"抱歉，未找到结果");
    }
}

//- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
//{
//    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
//    [_mapView removeAnnotations:array];
//    array = [NSArray arrayWithArray:_mapView.overlays];
//    [_mapView removeOverlays:array];
//    if (error == 0) {
//        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
//        item.coordinate = result.location;
//        item.title = result.address;
//        [_mapView addAnnotation:item];
//        _mapView.centerCoordinate = result.location;
//        NSString* titleStr;
//        NSString* showmeg;
//        titleStr = @"正向地理编码";
//        showmeg = [NSString stringWithFormat:@"经度:%f,纬度:%f",item.coordinate.latitude,item.coordinate.longitude];
//    }
//}




- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorGreen;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    CGFloat a = userLocation.location.coordinate.latitude;
    CGFloat b = userLocation.location.coordinate.longitude;
    NSLog(@"========%f,++++++++%f",a,b);
#pragma mark -- 将定位到的位置赋给相对应的值并将定位的位置放到中间
    self.coor =CLLocationCoordinate2DMake(a, b);
    _mapView.centerCoordinate = self.coor;
    
    _mapView.showsUserLocation = YES;//显示定位图层
    [_mapView updateLocationData:userLocation];
    NSLog(@"坐标更新");
}
/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)mapViewWillStartLocatingUser:(BMKMapView *)mapView
{
    NSLog(@"start locate");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    NSLog(@"heading is %@",userLocation.heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    BMKCoordinateRegion region;
    
    region.center.longitude = userLocation.location.coordinate.longitude;
    
    region.center.latitude = userLocation.location.coordinate.latitude;
    
    region.span.latitudeDelta = 0.005;
    
    region.span.longitudeDelta = 0.005;
    
    if (_mapView) {
        
        _mapView.region = region;
        
        
    }
    _mapView.centerCoordinate = self.coor;
}

/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)mapViewDidStopLocatingUser:(BMKMapView *)mapView
{
    NSLog(@"stop locate");
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
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
