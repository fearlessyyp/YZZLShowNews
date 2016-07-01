//
//
//
//  url:http://www.xiongcaichang.com
//  Created by bear on 16/3/31.
//  Copyright © 2016年 bear. All rights reserved.
//
#import <UIKit/UIKit.h>


static const CGFloat MaxHeight = 200;



@interface ScalableCover : UIImageView

@property (nonatomic, strong) UIScrollView *scrollView;


@end




@interface UIScrollView (ScalableCover)

@property (nonatomic, weak) ScalableCover *scalableCover;

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) UIImageView *bigImage;


- (UIButton *)addScalableCoverWithImage:(UIImage *)image URLStr:(NSString *)url;
- (void)removeScalableCover;

@end

