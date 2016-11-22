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
#import <MediaPlayer/MediaPlayer.h>
#import "SYVideoView.h"
#import "SYVideoController.h"

#define video1 @"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4"
#define video2 @"http://v.jxvdy.com/sendfile/w5bgP3A8JgiQQo5l0hvoNGE2H16WbN09X-ONHPq3P3C1BISgf7C-qVs6_c8oaw3zKScO78I--b0BGFBRxlpw13sf2e54QA"
#define video3 @"http://videoplay.ejucloud.com/newcode-38797d--20161117143021.mp4"
#define video4 @"http://pl.youku.com/playlist/m3u8?vid=162779600&ts=1407469897&ctype=12&token=3357&keyframe=1&sid=640746989782612d6cc70&ev=1&type=flv&ep=dCaUHU2LX8YJ4ivdjj8bMyqxJ3APXP8M9BiCiNRiANQnS%2B24&oip=2043219268"

@interface ViewController ()
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerViewController  *playerView;
@property (nonatomic, strong) SYVideoView *videoView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.videoView];
    self.videoView.videoUrl = video1;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - 开始按钮响应方法
- (IBAction)startPlayer:(id)sender {
    self.videoView.videoUrl = video4;
}
#pragma mark - 暂停按钮响应方法
- (IBAction)stopPlayer:(id)sender {
//    NSURL *url = [[NSURL alloc] initWithString:video1];
//    MPMoviePlayerViewController *player = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
//    
//    [self presentMoviePlayerViewControllerAnimated:player];
    SYVideoController *vc = [[SYVideoController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (SYVideoView *)videoView {
    if (_videoView == nil) {
        _videoView = [[SYVideoView alloc] initWithFrame:CGRectMake(0, 20,self.view.frame.size.width , 250*self.view.frame.size.width/320)];
    }
    return _videoView;
}

@end
