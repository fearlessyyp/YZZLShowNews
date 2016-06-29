//
//  UITableView+Touches.m
//  ShowNews
//
//  Created by ZZQ on 16/6/29.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import "UITableView+Touches.h"

@implementation UITableView (Touches)
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![self isMemberOfClass:[UITableView class]]) {
        
    } else {
        [[self nextResponder] touchesBegan:touches withEvent:event];
        if ([super respondsToSelector:@selector(touchesBegan:withEvent:)]) {
            [super touchesBegan:touches withEvent:event];
        }
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![self isMemberOfClass:[UITableView class]]) {
        
    } else {
        [[self nextResponder] touchesMoved:touches withEvent:event];
        if ([super respondsToSelector:@selector(touchesBegan:withEvent:)]) {
            [super touchesMoved:touches withEvent:event];
        }
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![self isMemberOfClass:[UITableView class]]) {
        
    } else {
        [[self nextResponder] touchesEnded:touches withEvent:event];
        if ([super respondsToSelector:@selector(touchesBegan:withEvent:)]) {
            [super touchesEnded:touches withEvent:event];
        }
    }
}

@end
