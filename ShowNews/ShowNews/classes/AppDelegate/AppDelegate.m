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
#import "UIImageView+WebCache.h"
#import "Simple.h"
#import "BNCoreServices.h"
#import <AVOSCloud/AVOSCloud.h>
#import <AudioToolbox/AudioToolbox.h>
#import<AVFoundation/AVFoundation.h>
#import "PlayViewController.h"

@interface AppDelegate ()<RESideMenuDelegate>

// 记录当前的系统亮度
@property (nonatomic, assign) float currentBrightness;
@property (nonatomic, strong) MusicSearchController *musicSearchVC;
@end



@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 记录当前的系统亮度
    _currentBrightness = [UIScreen mainScreen].brightness;
    if ([Simple sharedSimple].moon == 1) {
        [UIScreen mainScreen].brightness = 0.2;
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    // 设置百度地图sdk
    [self setBaiduMap];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [self settabbarItemTextAttributes];
    self.rootTVC = [[UITabBarController alloc] init];
    // 设置抽屉
    [self setRESideMenu];
    // 创建子控制器
    [self createChildViewControllers];
    
    // NavigationBar设置
    [UINavigationBar appearance].barStyle = UIBarStyleBlack;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
     //设置友盟的相关信息
    [self setup_UMAppKey];
    
    // leanCloud设置
    [self setLeanCloud];
    
    //初始化导航DSK
    [BNCoreServices_Instance initServices:@"o5H8GiR7jg4w0UrP9mVOGPt2WGm4dnpy"];
//    [BNCoreServices_Instance startServicesAsyn:nil fail:nil];
#warning 这里被周子琦修改了  原句被注释
    [BNCoreServices_Instance startServices];
    
    
    //监听耳机插入和拔出
    //监听耳机事件
    
    [[AVAudioSession sharedInstance] setDelegate:self];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    AudioSessionAddPropertyListener(
                                                      kAudioSessionProperty_AudioRouteChange,
                                                      audioRouteChangeListenerCallback,(__bridge void *)(self));
    
    AudioSessionInitialize(NULL, NULL, interruptionListenner, (__bridge void*)self);
    
    return YES;
}




#pragma mark - 设置leanCloud
- (void)setLeanCloud {
    // applicationId 即 App Id，clientKey 是 App Key。
    [AVOSCloud setApplicationId:@"i4IpGwRm4rQCHeBH12zLBlxt-gzGzoHsz"
                      clientKey:@"kKMIOipPwcuk5NDM37HQ3YNC"];
    

}

#pragma mark - 设置抽屉
- (void)setRESideMenu {
    self.musicSearchVC = [MusicSearchController sharedMusicSearchController];
    RESideMenu *sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:self.rootTVC
                                                                    leftMenuViewController:nil
                                                                   rightMenuViewController:self.musicSearchVC];
    sideMenuViewController.menuPreferredStatusBarStyle = 1; // UIStatusBarStyleLightContent
    sideMenuViewController.delegate = self;
    // 关闭重量感应
    sideMenuViewController.parallaxEnabled = NO;
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
                                         RedirectURL:@"http://baidu.com"];
    
    //    //设置分享到QQ空间的应用Id，和分享url 链接
    [UMSocialQQHandler setQQWithAppId:@"100424468" appKey:@"c7394704798a158208a74ab60104f0ba" url:@"http://www.umeng.com/social"];
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

- (void)setBaiduMap {
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"7Zq4UCFL3K01ezb5wTldFdUoFGnMcl3A"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
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
    VideoViewController *videoVC = [[VideoViewController alloc] init];
    [self addOneChildViewController:videoVC title:@"视频" normalImage:@"tabbar_icon_media_normal@2x" selectedImage:@"tabbar_icon_media_highlight@2x"];
    [self addOneChildViewController:[[MapViewController alloc] init] title:@"地图" normalImage:@"tabbar_icon_map_normal@2x" selectedImage:@"tabbar_icon_map_highlight@2x"];
    UserViewController *userVC = [[UserViewController alloc] init];
    userVC.musicSearchVC = self.musicSearchVC;
    [self addOneChildViewController:userVC title:@"我" normalImage:@"tabbar_icon_me_normal@2x" selectedImage:@"tabbar_icon_me_highlight@2x"];
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
    [[UIScreen mainScreen] setBrightness:_currentBrightness];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [application beginReceivingRemoteControlEvents];
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
  
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    if ([Simple sharedSimple].moon == 1) {
        [UIScreen mainScreen].brightness = 0.2;
    }
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


//播放音乐文件打断处理
void interruptionListenner(void* inClientData, UInt32 inInterruptionState)

{
    AppDelegate* pTHIS = (__bridge AppDelegate*)inClientData;
    //AppDelegate *applegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if (pTHIS) {
        NSLog(@"interruptionListenner %d", (unsigned int)inInterruptionState);
        if (kAudioSessionBeginInterruption == inInterruptionState) {
            NSLog(@"Begin interruption");//开始打断打断处理
            [[PlayerManager sharePlayer] pause];
        }
        else if (inInterruptionState == kAudioSessionEndInterruption)
        {
            NSLog(@"End end interruption");//结束打断处理
            [[PlayerManager sharePlayer] musicPlay];
        }
    }
}






void audioRouteChangeListenerCallback (
                                       void                      *inUserData,
                                       AudioSessionPropertyID    inPropertyID,
                                       UInt32                    inPropertyValueS,
                                       const void                *inPropertyValue
                                       ) {
    if (inPropertyID != kAudioSessionProperty_AudioRouteChange) return;
    {
        CFDictionaryRef routeChangeDictionary = (CFDictionaryRef)inPropertyValue;
        CFNumberRef routeChangeReasonRef = (CFNumberRef)CFDictionaryGetValue (routeChangeDictionary, CFSTR (kAudioSession_AudioRouteChangeKey_Reason) );
        SInt32 routeChangeReason;
        CFNumberGetValue (routeChangeReasonRef, kCFNumberSInt32Type, &routeChangeReason);

        if (routeChangeReason == kAudioSessionRouteChangeReason_OldDeviceUnavailable) {
            DLog(@"没有耳机！");
            NSLog(@"ahah");
            [[MusicSearchController sharedMusicSearchController].palyButton setImage:[UIImage imageNamed:@"audionews_play_button@2x"] forState:UIControlStateNormal];
            [[PlayViewController sharePlayView].playButton setImage:[UIImage imageNamed:@"audionews_play_button@2x"] forState:UIControlStateNormal];
            [[PlayerManager sharePlayer] pause];
        } else if (routeChangeReason == kAudioSessionRouteChangeReason_NewDeviceAvailable) {
            
            //Handle Headset plugged in
            
            DLog(@"有耳机！");
            
        }
    }
    
}

@end
