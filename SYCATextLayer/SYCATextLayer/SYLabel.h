//
//  SYLabel.h
//  SYCATextLayer
//
//  Created by leju_esf on 16/11/25.
//  Copyright © 2016年 tsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYLabel : UIView
@property (nonatomic, copy) id text;
@property (nonatomic, copy) NSString *linkText;
@property (nonatomic, strong) UIColor *linkTextColor;
@end
