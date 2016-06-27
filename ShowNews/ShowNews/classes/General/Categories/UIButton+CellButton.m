//
//  UIButton+CellButton.m
//  WXPlayer
//
//  Created by lanou3g on 16/6/15.
//  Copyright © 2016年 wxerters. All rights reserved.
//

#import "UIButton+CellButton.h"
#import <objc/runtime.h>
const void *key = "key";
@implementation UIButton (CellButton)
@dynamic indexPath;
- (void)setIndexPath:(NSIndexPath *)indexPath{
    objc_setAssociatedObject(self, key, indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSIndexPath *)indexPath{
    return objc_getAssociatedObject(self, key);
}


@end
