//
//  AppDelegate.h
//  ShowNews
//
//  Created by YYP on 16/6/24.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    BMKMapManager* _mapManager;
}


@property (strong, nonatomic) UIWindow *window;


@end

