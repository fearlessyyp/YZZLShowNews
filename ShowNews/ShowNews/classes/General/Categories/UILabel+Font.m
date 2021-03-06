//
//  UILabel+Font.m
//  
//
//  Created by ZZQ on 16/6/24.
//  Copyright © 2016年 ZZQ. All rights reserved.
//

#import "UILabel+Font.h"
#import "Simple.h"

#define IPHONE_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SizeScale ((IPHONE_HEIGHT > 568) ? IPHONE_HEIGHT/ 568 : 1)

@implementation UILabel (Font)
//不同设备的屏幕比例(当然倍数可以自己控制)

+ (void)load{
    Method imp = class_getInstanceMethod([self class], @selector(initWithCoder:));
    Method myImp = class_getInstanceMethod([self class], @selector(myInitWithCoder:));
    method_exchangeImplementations(imp, myImp);
    NSLog(@"======================%f", [Simple sharedSimple].size);
}

- (id)myInitWithCoder:(NSCoder*)aDecode{
    
    
    [self myInitWithCoder:aDecode];
    if (self) {
        //部分不像改变字体的 把tag值设置成333跳过
        if(self.tag != 333){
            CGFloat fontSize = self.font.pointSize;
            self.font = [UIFont systemFontOfSize:fontSize * SizeScale];
        }
    }
    return self;
}

@end
