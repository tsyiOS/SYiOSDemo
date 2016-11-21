//
//  RTHVideoInfoVideoView.h
//  儒思HR
//
//  Created by Yala on 15/8/28.
//  Copyright (c) 2015年 Yala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "RTHVideoInfoVideoToolBar.h"
@class RTHVideoInfoVideoView;
@protocol RTHVideoInfoVideoViewDelegate <NSObject>

@optional
- (void)videoView:(RTHVideoInfoVideoView *)videoView didSelectZoom:(UIButton *)zoomBtn;

@end

@interface RTHVideoInfoVideoView : UIView

@property (nonatomic, weak) id <RTHVideoInfoVideoViewDelegate> delegate;

//视频工具栏
@property (nonatomic, strong) RTHVideoInfoVideoToolBar *videoToolBar;

//视频播放器
@property (nonatomic, strong) AVPlayer *player;

//视频填充模式
@property (nonatomic, copy) NSString *fillMode;

//视频地址
@property (nonatomic, copy) NSString *videoURL;

//播放视频项
@property (nonatomic, strong) AVPlayerItem *item;

//player observer
@property (nonatomic) id timeObserver;

//全屏或非全屏时设置按钮状态
@property (nonatomic, assign, getter=isFullScreen) BOOL fullScreen;

@end
