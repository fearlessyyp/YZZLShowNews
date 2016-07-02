//
//  Simple.m
//  ShowNews
//
//  Created by ZZQ on 16/7/1.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import "Simple.h"

@implementation Simple
singleton_implementation(Simple);

- (float)size {
    if (_size < 400) {
        return 568;
    }else
        return _size;
}

- (float)scale {
    if (_scale < 0.5) {
        return 1;
    }else
        return _scale;
}

@end
