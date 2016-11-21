//
//  ViewController.m
//  SYVideoPlay
//
//  Created by leju_esf on 16/11/21.
//  Copyright © 2016年 tsy. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "SYVideoView.h"

#define video1 @"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4"
#define video2 @"http://v.jxvdy.com/sendfile/w5bgP3A8JgiQQo5l0hvoNGE2H16WbN09X-ONHPq3P3C1BISgf7C-qVs6_c8oaw3zKScO78I--b0BGFBRxlpw13sf2e54QA"

@interface ViewController ()
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerViewController  *playerView;
@property (nonatomic, strong) SYVideoView *videoView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.videoView];
}

#pragma mark - 开始按钮响应方法
- (IBAction)startPlayer:(id)sender {
    [self.videoView play];
}
#pragma mark - 暂停按钮响应方法
- (IBAction)stopPlayer:(id)sender {
    [self.videoView pause];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (SYVideoView *)videoView {
    if (_videoView == nil) {
        _videoView = [[SYVideoView alloc] initWithFrame:CGRectMake(0, 20,self.view.frame.size.width , 200)];
    }
    return _videoView;
}

@end
