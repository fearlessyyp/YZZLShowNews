//
//  ViewController.m
//  ShowNews
//
//  Created by YYP on 16/6/24.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import "ViewController.h"
#import "NewsController.h"
#import "VideoTableViewController.h"
#import "MusicSearchController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    VideoTableViewController *VTVC = [[VideoTableViewController alloc] init];
    [self.navigationController pushViewController:VTVC animated:YES];
//    MusicSearchController *VTVC = [[MusicSearchController alloc] init];
//    [self.navigationController pushViewController:VTVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
