//
//  RKDoubleSlider.h
//  VideoCutterDemo
//
//  Created by leju_esf on 17/3/1.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RKDoubleSliderDelegate <NSObject>

@optional
- (void)sliderMoveActionFirstValue:(float)firstValue andSecondValue:(float)secondValue;
- (void)sliderEndActionFirstValue:(float)firstValue andSecondValue:(float)secondValue;
@end

@interface RKDoubleSlider : UIView
@property (nonatomic) float firstValue;
@property (nonatomic) float secondValue;

@property (nonatomic) float minmumValue;
@property (nonatomic) float maxmumValue;

@property (nullable,nonatomic,strong) UIImage *  firstSliderImg;
@property (nullable,nonatomic,strong) UIImage * secondSliderImg;

@property(nullable, nonatomic,strong) UIColor *minimumTrackTintColor ;
@property(nullable, nonatomic,strong) UIColor *maximumTrackTintColor;
@property(nullable, nonatomic,strong) UIColor *thumbTintColor ;

@property (nullable,nonatomic, weak) id <RKDoubleSliderDelegate> delegate;
@end
