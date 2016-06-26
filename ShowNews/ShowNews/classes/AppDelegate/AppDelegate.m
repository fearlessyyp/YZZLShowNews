//
//  AppDelegate.m
//  ShowNews
//
//  Created by YYP on 16/6/24.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "MapViewController.h"
#import "MusicSearchController.h"
#import "NewsViewController.h"
#import "UserViewController.h"
#import "VideoTableViewController.h"
#import <RESideMenu.h>

@interface AppDelegate ()<RESideMenuDelegate>
@property (nonatomic, strong) UITabBarController *rootTVC;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    self.rootTVC = [[UITabBarController alloc] init];
    [self createChildViewControllers];
    
    MusicSearchController *musicVC = [[MusicSearchController alloc] init];
    RESideMenu *sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:self.rootTVC
                                                                    leftMenuViewController:nil
                                                                   rightMenuViewController:musicVC];
    sideMenuViewController.menuPreferredStatusBarStyle = 1; // UIStatusBarStyleLightContent
    sideMenuViewController.delegate = self;
    sideMenuViewController.contentViewShadowColor = [UIColor blackColor];
    sideMenuViewController.contentViewShadowOffset = CGSizeMake(0, 0);
    sideMenuViewController.contentViewShadowOpacity = 0.6;
    sideMenuViewController.contentViewShadowRadius = 12;
    sideMenuViewController.contentViewShadowEnabled = YES;
    // 抽屉效果不变小
    sideMenuViewController.scaleContentView = NO;
    // 设置不能侧滑效果
    sideMenuViewController.panGestureEnabled = NO;
    // 设置平移偏移量
    sideMenuViewController.contentViewInLandscapeOffsetCenterX = [UIScreen mainScreen].bounds.size.width * 0.35;
    sideMenuViewController.contentViewInPortraitOffsetCenterX  = [UIScreen mainScreen].bounds.size.width * 0.35;
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:sideMenuViewController];
    // Override point for customization after application launch.
    return YES;
}


#pragma mark - 创建四个根视图控制器
- (void)createChildViewControllers {
    [self addOneChildViewController:[[NewsViewController alloc] init] title:@"新闻" normalImage:nil selectedImage:nil];
    [self addOneChildViewController:[[VideoTableViewController alloc] init] title:@"视频" normalImage:nil selectedImage:nil];
    [self addOneChildViewController:[[MapViewController alloc] init] title:@"地图" normalImage:nil selectedImage:nil];
    [self addOneChildViewController:[[UserViewController alloc] init] title:@"我" normalImage:nil selectedImage:nil];
}

#pragma mark - 添加控制器
- (void)addOneChildViewController:(UIViewController *)viewController
                            title:(NSString *)title
                      normalImage:(NSString *)normalImage
                    selectedImage:(NSString *)selectedImage{
    viewController.title = title;
    viewController.tabBarItem.image = [UIImage imageNamed:normalImage];
    UIImage *image = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem.selectedImage = image;
    UINavigationController *mainNC = [[UINavigationController alloc] initWithRootViewController:viewController];
//    // 添加子控制器
    [self.rootTVC addChildViewController:mainNC];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
