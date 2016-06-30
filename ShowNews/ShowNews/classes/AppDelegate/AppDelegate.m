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
#import "VideoViewController.h"
#import <RESideMenu.h>
#import "UIImage+ImageByColor.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import <UMSocial.h>
#import "PlayerManager.h"
#import "Music.h"
#import <UIImageView+WebCache.h>
@interface AppDelegate ()<RESideMenuDelegate>
@property (nonatomic, strong) UITabBarController *rootTVC;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [self settabbarItemTextAttributes];
    self.rootTVC = [[UITabBarController alloc] init];
    [self createChildViewControllers];
//    self.rootTVC.tabBar.backgroundImage = [UIImage imageNamed:@"bg_nav"];
    MusicSearchController *musicVC = [[MusicSearchController alloc] init];
    RESideMenu *sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:self.rootTVC
                                                                    leftMenuViewController:nil
                                                                   rightMenuViewController:musicVC];
    sideMenuViewController.menuPreferredStatusBarStyle = 1; // UIStatusBarStyleLightContent
    sideMenuViewController.delegate = self;
    // 抽屉效果不变小
    sideMenuViewController.scaleContentView = NO;
    // 设置不能侧滑效果
    sideMenuViewController.panGestureEnabled = NO;
    // 设置平移偏移量
    sideMenuViewController.contentViewInLandscapeOffsetCenterX = [UIScreen mainScreen].bounds.size.width * 0.33;
    sideMenuViewController.contentViewInPortraitOffsetCenterX  = [UIScreen mainScreen].bounds.size.width * 0.33;
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:sideMenuViewController];
//    self.window.rootViewController = sideMenuViewController;
    [UINavigationBar appearance].barStyle = UIBarStyleBlack;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    //    //设置友盟的相关信息
    [self setup_UMAppKey];
    return YES;
}

#pragma mark - 设置友盟的相关信息
- (void)setup_UMAppKey{
    
    [UMSocialData setAppKey:UmengAppkey];
    //设置微信AppId，设置分享url，默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:@"wxdc1e388c3822c80b" appSecret:@"a393c1527aaccb95f3a4c88d6d1455f6" url:@"http://www.umeng.com/social"];
    
    // 打开新浪微博的SSO开关
    // 将在新浪微博注册的应用appkey、redirectURL替换下面参数，并在info.plist的URL Scheme中相应添加wb+appkey，如"wb3921700954"，详情请参考官方文档。
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"2280572209"
                                              secret:@"1047a3dd53f079493337fad696dad8fc"
                                         RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    //    //设置分享到QQ空间的应用Id，和分享url 链接
    [UMSocialQQHandler setQQWithAppId:@"1105505058" appKey:@"qXriypWLjaMHYKv2" url:@"http://www.umeng.com/social"];
    //设置支持没有客户端情况下使用SSO授权
    [UMSocialQQHandler setSupportWebView:YES];
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
    }
    return result;
}


#pragma mark - 设置babbarItem文本标题颜色
- (void)settabbarItemTextAttributes {
    // 设置普通状态下的文本呢颜色
    NSMutableDictionary *normalAttr = [NSMutableDictionary dictionary];
    normalAttr[NSForegroundColorAttributeName] = [UIColor grayColor];
    // 设置选中后文本颜色
    NSMutableDictionary *selectedAttr = [NSMutableDictionary dictionary];
    [selectedAttr setObject:NEWS_COLOR(199, 0, 28, 1.0) forKey:NSForegroundColorAttributeName];
    // 配置文本属性
    UITabBarItem *tabbarItem = [UITabBarItem appearance];
    [tabbarItem setTitleTextAttributes:normalAttr forState:UIControlStateNormal];
    [tabbarItem setTitleTextAttributes:selectedAttr forState:UIControlStateSelected];
}

#pragma mark - 创建四个根视图控制器
- (void)createChildViewControllers {
    [self addOneChildViewController:[[NewsViewController alloc] init] title:@"新闻" normalImage:@"tabbar_icon_news_normal@2x" selectedImage:@"tabbar_icon_news_highlight@2x"];
    [self addOneChildViewController:[[VideoViewController alloc] init] title:@"视频" normalImage:@"tabbar_icon_media_normal@2x" selectedImage:@"tabbar_icon_media_highlight@2x"];
    [self addOneChildViewController:[[MapViewController alloc] init] title:@"地图" normalImage:@"tabbar_icon_map_normal@2x" selectedImage:@"tabbar_icon_map_highlight@2x"];
    [self addOneChildViewController:[[UserViewController alloc] init] title:@"我" normalImage:@"tabbar_icon_me_normal@2x" selectedImage:@"tabbar_icon_me_highlight@2x"];
}

#pragma mark - 添加控制器
- (void)addOneChildViewController:(UIViewController *)viewController
                            title:(NSString *)title
                      normalImage:(NSString *)normalImage
                    selectedImage:(NSString *)selectedImage{
    viewController.title = title;
    viewController.view.backgroundColor = [UIColor whiteColor];
    viewController.tabBarItem.image = [UIImage imageNamed:normalImage];
    UIImage *image = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem.selectedImage = image;
    UINavigationController *mainNC = [[UINavigationController alloc] initWithRootViewController:viewController];
    mainNC.navigationBar.translucent = NO;
    // 添加子控制器
    [self.rootTVC addChildViewController:mainNC];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [application beginReceivingRemoteControlEvents];
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

-(void)remoteControlReceivedWithEvent:(UIEvent *)event{
//    [self configNowPlayingInfoCenter];
    //if it is a remote control event handle it correctly
    if (event.type == UIEventTypeRemoteControl) {
        
        switch (event.subtype) {
                
//            case UIEventSubtypeRemoteControlTogglePlayPause:
//                [[PlayerManager sharePlayer] pause];
//                break;
                
            case UIEventSubtypeRemoteControlPreviousTrack:
                [[PlayerManager sharePlayer] upMusic];
                break;
                
            case UIEventSubtypeRemoteControlNextTrack:
                [[PlayerManager sharePlayer] nextMusic];
                
                break;
                
            case UIEventSubtypeRemoteControlPlay:
                [[PlayerManager sharePlayer] musicPlay];
                break;
                
            case UIEventSubtypeRemoteControlPause:
                [[PlayerManager sharePlayer] pause];
                break;
                
            default:
                break;
        }
        
    }
    
}


//Make sure we can recieve remote control events

- (BOOL)canBecomeFirstResponder {
    
    return YES;
    
}


//锁屏封面

//一般在每次切换歌曲或者更新信息的时候要调用这个方法
- (void)configNowPlayingInfoCenter {
    
    
    if (NSClassFromString(@"MPNowPlayingInfoCenter")) {
        
        [PlayerManager sharePlayer].bloclAPP = ^(Music *music) {
            NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
            
            [dict setObject:music.musicName forKey:MPMediaItemPropertyTitle];
            
            [dict setObject:music.singerName forKey:MPMediaItemPropertyArtist];
            
            [dict setObject:music.specialName forKey:MPMediaItemPropertyAlbumTitle];
            
            NSLog(@"hahahahahahahhahaha==== %@", music.musicName);
            //            dispatch_async(dispatch_get_main_queue(), ^{
            //                UIImageView *musicImage = [[UIImageView alloc] init];
            //                [musicImage sd_setImageWithURL:[NSURL URLWithString:music.picUrl]];
            //
            //                MPMediaItemArtwork * mArt = [[MPMediaItemArtwork alloc] initWithImage:musicImage.image];
            //
            //                [dict setObject:mArt forKey:MPMediaItemPropertyArtwork];
            //            });
            
            
            [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = nil;
            
            [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
            
            
        };
        
        
        
    }
    
}



@end
