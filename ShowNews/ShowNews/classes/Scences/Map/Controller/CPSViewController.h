//
//  CPSViewController.h
//  ShowNews
//
//  Created by ZC on 16/7/2.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNRoutePlanModel.h"
#import "BNCoreServices.h"
@interface CPSViewController : UIViewController
@property (nonatomic, assign) CLLocationCoordinate2D startNode;
@property (nonatomic, assign) CLLocationCoordinate2D endNode;
@end
