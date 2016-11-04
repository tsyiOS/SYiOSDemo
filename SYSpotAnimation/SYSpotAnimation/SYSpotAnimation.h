//
//  SYSpotAnimation.h
//  SYSpotAnimation
//
//  Created by leju_esf on 16/11/4.
//  Copyright © 2016年 tsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYSpotAnimation : NSObject
/**
 *  在某个按钮上展示牛、B动画
 *
 *  @param angle 出场的角度(向上偏移为正，向下偏移为负)最好设置在-45到45之间
 *  @param view  依赖的view 点击的时候传按钮就行
 */
+ (void)sy_animationWithOffset:(CGFloat)angle onView:(UIView *)view;
/**
 *  在某个点上展示牛、B动画
 *
 *  @param angle 出场的角度(向上偏移为正，向下偏移为负)最好设置在-45到45之间
 *  @param view  依赖的view 点击的时候传按钮就行
 */
+ (void)sy_animationWithOffset:(CGFloat)angle onPoint:(CGPoint)point;
@end
