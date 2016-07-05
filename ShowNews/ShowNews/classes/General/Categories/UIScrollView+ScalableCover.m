//
//
//
//  url:http://www.xiongcaichang.com
//  Created by bear on 16/3/31.
//  Copyright © 2016年 bear. All rights reserved.
//



#import "UIScrollView+ScalableCover.h"
#import <objc/runtime.h>
#import "UIImageView+WebCache.h"
static NSString * const kContentOffset = @"contentOffset";
static NSString * const kScalableCover = @"scalableCover";
static NSString * const kButton = @"button";
static NSString * const kBigImage = @"bigImage";

@implementation UIScrollView (ScalableCover)

- (void)setScalableCover:(ScalableCover *)scalableCover
{
    [self willChangeValueForKey:kScalableCover];
    objc_setAssociatedObject(self, @selector(scalableCover),
                             scalableCover,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:kScalableCover];
}

- (ScalableCover *)scalableCover
{
    return objc_getAssociatedObject(self, &kScalableCover);
}

- (void)setButton:(UIButton *)button {
//    [self willChangeValueForKey:kButton];
    objc_setAssociatedObject(self, &kButton,
                             button,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    [self didChangeValueForKey:kButton];
}

- (UIButton *)button
{
    return objc_getAssociatedObject(self, &kButton);
}

- (void)setBigImage:(UIImageView *)bigImage {
//    [self willChangeValueForKey:kBigImage];
    objc_setAssociatedObject(self, &kBigImage, bigImage,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    [self didChangeValueForKey:kBigImage];
}

- (UIImageView *)bigImage {
    return objc_getAssociatedObject(self, &kBigImage);
}


- (UIButton *)addScalableCoverWithImage:(UIImage *)image URLStr:(NSString *)url
{
    ScalableCover *cover = [[ScalableCover alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, MaxHeight)];
    
    cover.backgroundColor = [UIColor clearColor];
    cover.image = image;
    cover.scrollView = self;
#warning - 50
    UIImageView *bigImage = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenSizeWidth / 2 - 50, 60 - 50, 100, 100)];
    bigImage.image = [UIImage imageNamed:@"comment_profile_default"];
    if (url) {
        [bigImage sd_setImageWithURL:[NSURL URLWithString:url]]; 
    }

    bigImage.layer.cornerRadius = 50;
    bigImage.layer.masksToBounds = YES;
    self.bigImage = bigImage;
    [cover addSubview:self.bigImage];
    

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
#warning - 50
    button.frame = CGRectMake(0, 165 - 50, kScreenSizeWidth, 30);
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.button = button;
    [self addSubview:self.button];
    
    [self addSubview:cover];
    [self sendSubviewToBack:cover];
//    cover.userInteractionEnabled = NO;
//    self.bigImage.userInteractionEnabled = NO;
//    self.button.userInteractionEnabled = YES;
    
    
    self.scalableCover = cover;
    return button;
}


- (void)removeScalableCover
{
    [self.scalableCover removeFromSuperview];
    self.scalableCover = nil;
}


@end




@interface ScalableCover (){

}



@end


@implementation ScalableCover

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;

    }

    return self;
}


- (void)setScrollView:(UIScrollView *)scrollView
{

    [_scrollView removeObserver:scrollView forKeyPath:kContentOffset];
    _scrollView = scrollView;
    [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}




- (void)removeFromSuperview
{


    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];

    NSLog(@"😄----removeed");
    [super removeFromSuperview];
}




- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.scrollView.contentOffset.y < 0) {
        CGFloat offset = -self.scrollView.contentOffset.y;
        
        self.frame = CGRectMake(-0, -offset, _scrollView.bounds.size.width + offset * 2, MaxHeight + offset);
#warning  -50
        _scrollView.button.center = CGPointMake(kScreenSizeWidth / 2 , 180 - 50);
        _scrollView.bigImage.center = CGPointMake(kScreenSizeWidth / 2, 110 - 50 + offset);
    } else {
 
//        CGFloat offset = -self.scrollView.contentOffset.y;
        self.frame = CGRectMake(0, 0, _scrollView.bounds.size.width, MaxHeight);

    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self setNeedsLayout];
}

//去掉 UItableview headerview 黏性(sticky)
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (scrollView == self.userTableView)
//    {
//        CGFloat sectionHeaderHeight = 60; //sectionHeaderHeight
//        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
//            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
//            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//        }
//    }
//}

@end
