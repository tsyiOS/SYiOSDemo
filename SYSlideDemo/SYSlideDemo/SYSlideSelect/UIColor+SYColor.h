//
//  UIColor+SYColor.h
//  SYSlideDemo
//
//  Created by leju_esf on 16/9/19.
//  Copyright © 2016年 tsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (SYColor)

@property (nonatomic,readonly) CGFloat sy_red;
@property (nonatomic,readonly) CGFloat sy_green;
@property (nonatomic,readonly) CGFloat sy_blue;
@property (nonatomic,readonly) CGFloat sy_alpha;

+ (UIColor *)sy_colorWithRGB:(u_int32_t)rgb;
+ (UIColor *)lineDefaultColor;

@end
