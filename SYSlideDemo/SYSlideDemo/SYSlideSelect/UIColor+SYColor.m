//
//  UIColor+SYColor.m
//  SYSlideDemo
//
//  Created by leju_esf on 16/9/19.
//  Copyright © 2016年 tsy. All rights reserved.
//

#import "UIColor+SYColor.h"

static short hexCharToShort(char a) {
    if (a >= '0' && a <= '9') {
        return a - '0';
    }
    else if( a>='a' && a<='f') {
        return a - 'a' + 10;
    }
    else if( a>= 'A' && a<='F') {
        return a - 'A' + 10;
    }
    else {
        return -1;
    }
}

@implementation UIColor (SYColor)

+ (UIColor *)sy_colorWithRGB:(u_int32_t)rgb {
    return [UIColor colorWithRed:((rgb&0xff0000)>>16)/255.0 green:((rgb&0xff00)>>8)/255.0 blue:(rgb&0xff)/255.0 alpha:1.0];
}

+ (UIColor *)lineDefaultColor {
    return  [self sy_colorWithRGB:0xdddddd];
}

- (CGFloat)sy_red {
    const CGFloat *components = CGColorGetComponents(self.CGColor);
    return components[0];
}

- (CGFloat)sy_green {
    const CGFloat *components = CGColorGetComponents(self.CGColor);
    return components[1];
}

- (CGFloat)sy_blue {
//    CGFloat red, green, blue, alpha;
//    [self getRed:&red green:&green blue:&blue alpha:&alpha];
//    return (NSInteger)(blue*225);
    const CGFloat *components = CGColorGetComponents(self.CGColor);
    return components[2];
}

- (CGFloat)sy_alpha {
    CGFloat red, green, blue, alpha;
    [self getRed:&red green:&green blue:&blue alpha:&alpha];
    return alpha;
}

@end
