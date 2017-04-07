//
//  RKProgressView.h
//  SYRecordVideoDemo
//
//  Created by leju_esf on 17/3/27.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RKProgressView : UIView
@property (nonatomic, assign) CGFloat progress;
+ (instancetype)progressView;
- (void)show;
- (void)dismiss;
@end
