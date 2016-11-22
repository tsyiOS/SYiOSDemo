//
//  SYVideoToolBar.h
//  SYVideoPlay
//
//  Created by leju_esf on 16/11/22.
//  Copyright © 2016年 tsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SYVideoToolBarDelegate <NSObject>

@required
- (void)playAction:(BOOL)play;

- (void)fullScreenAction:(BOOL)fullScreen;

@end

@interface SYVideoToolBar : UIView

@property (nonatomic, assign) NSInteger totalTime;
@property (nonatomic, assign) NSInteger currentTime;

@property (nonatomic, weak) id<SYVideoToolBarDelegate>delegate;
@end
