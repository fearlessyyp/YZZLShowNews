//
//  ViewController.m
//  ShowNews
//
//  Created by YYP on 16/6/24.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import "ViewController.h"
#import "VideoViewController.h"
#import "MusicSearchController.h"
#import "WeatherHandle.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    VideoTableViewController *VTVC = [[VideoTableViewController alloc] init];
//    VideoTableViewController *VTVC = [[VideoTableViewController alloc] init];
//    [self.navigationController pushViewController:VTVC animated:YES];
//    MusicSearchController *VTVC = [[MusicSearchController alloc] init];
//    [self.navigationController pushViewController:VTVC animated:YES];
//    testViewController *VTVC = [[testViewController alloc] init];
    MusicSearchController *VTVC = [[MusicSearchController alloc] init];
    [self.navigationController pushViewController:VTVC animated:YES];
//    testViewController *VTVC = [[testViewController alloc] init];
//    [self.navigationController pushViewController:VTVC animated:YES];
//    MusicSearchController *VTVC = [[MusicSearchController alloc] init];
//    [self.navigationController pushViewController:VTVC animated:YES];
//    [WeatherHandle sharedWeatherHandle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
