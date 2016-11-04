//
//  SYSpotAnimation.m
//  SYSpotAnimation
//
//  Created by leju_esf on 16/11/4.
//  Copyright © 2016年 tsy. All rights reserved.
//

#import "SYSpotAnimation.h"

@implementation SYSpotAnimation
+ (void)sy_animationWithOffset:(CGFloat)angle onView:(UIView *)view {
    CGPoint point = [[UIApplication sharedApplication].keyWindow convertPoint:view.center fromView:view.superview];
    [self sy_animationWithOffset:angle onPoint:point];
}

+ (void)sy_animationWithOffset:(CGFloat)angle onPoint:(CGPoint)point {
    for (int i = 0; i < 6; i++) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(i*0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            UIImage *niuImage = [UIImage imageNamed:@"icon_niu"];
            UIImage *bImage = [UIImage imageNamed:@"icon_b"];
            
            UIImageView *imageViewB = [[UIImageView alloc] initWithImage:bImage];
            UIImageView *imageViewNiu = [[UIImageView alloc] initWithImage:niuImage];
            
            CGFloat randomB = arc4random_uniform(100)/200.0;
            CGFloat randomNiu = arc4random_uniform(100)/200.0;
            
            imageViewB.frame = CGRectMake(point.x, point.y, niuImage.size.width*randomB, niuImage.size.height*randomB);
            imageViewNiu.frame = CGRectMake(point.x, point.y, niuImage.size.width*randomNiu, niuImage.size.height*randomNiu);
            
            [[UIApplication sharedApplication].keyWindow addSubview:imageViewNiu];
            [[UIApplication sharedApplication].keyWindow addSubview:imageViewB];
            
            NSInteger topBottom = arc4random_uniform(10)%2 == 0 ? -1:1;
            [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                imageViewB.center = CGPointMake(arc4random_uniform(500)*0.1+point.x,topBottom*arc4random_uniform(1000)*0.1+point.y);
                imageViewNiu.center = CGPointMake(arc4random_uniform(500)*0.1+point.x,topBottom*arc4random_uniform(1000)*0.1+point.y);
            }completion:nil];
            
            CGFloat quitY = point.y - ([UIScreen mainScreen].bounds.size.width - point.x)*tan(M_PI*angle/180);
            [UIView animateWithDuration:0.6 delay:0.4 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                imageViewNiu.center = CGPointMake([UIScreen mainScreen].bounds.size.width + niuImage.size.width, quitY);
                imageViewB.center = CGPointMake([UIScreen mainScreen].bounds.size.width + bImage.size.width, quitY);
            } completion:^(BOOL finished) {
                [imageViewNiu removeFromSuperview];
                [imageViewB removeFromSuperview];
            }];
        });
    }
}
@end
