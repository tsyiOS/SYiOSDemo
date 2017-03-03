//
//  SYVideoView.h
//  SYVideoPlay
//
//  Created by leju_esf on 16/11/21.
//  Copyright © 2016年 tsy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol SYVideoViewDelegate <NSObject>

@optional
- (void)sy_fullScreen:(BOOL)fullScreen;

@end

@interface SYVideoView : UIView
@property (nonatomic, weak) id<SYVideoViewDelegate>delegate;
@property (nonatomic, copy) NSString *videoUrl;

- (void)play;
- (void)pause;
@end
