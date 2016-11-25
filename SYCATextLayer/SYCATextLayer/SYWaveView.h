//
//  SYWaveView.h
//  SYCATextLayer
//
//  Created by leju_esf on 16/11/25.
//  Copyright © 2016年 tsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYWaveView : UIView
/**
 *  波纹振幅 默认30
 */
@property (nonatomic ,assign) CGFloat waveAmplitude;
/**
 *  振幅周期 默认200
 */
@property (nonatomic ,assign) CGFloat waveCycle;
/**
 *  波纹速度 默认 0.2
 */
@property (nonatomic ,assign) CGFloat waveSpeed;
/**
 *  波纹颜色 默认橙色
 */
@property (nonatomic, strong) UIColor *waveColor;
/**
 *  数值 默认0.5 范围0~1.0
 */
@property (nonatomic, assign) CGFloat value;
@end
