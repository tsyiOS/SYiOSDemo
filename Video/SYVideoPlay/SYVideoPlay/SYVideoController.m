//
//  SYVideoController.m
//  SYVideoPlay
//
//  Created by leju_esf on 16/11/22.
//  Copyright © 2016年 tsy. All rights reserved.
//

#import "SYVideoController.h"
#import "SYVideoView.h"
#import "UIImage+SYExtension.h"
#import "UIView+SYExtension.h"
#import "AppDelegate.h"

#define video1 @"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4"
#define video2 @"http://v.jxvdy.com/sendfile/w5bgP3A8JgiQQo5l0hvoNGE2H16WbN09X-ONHPq3P3C1BISgf7C-qVs6_c8oaw3zKScO78I--b0BGFBRxlpw13sf2e54QA"
#define video3 @"http://videoplay.ejucloud.com/newcode-38797d--20161117143021.mp4"
#define video4 @"http://pl.youku.com/playlist/m3u8?vid=162779600&ts=1407469897&ctype=12&token=3357&keyframe=1&sid=640746989782612d6cc70&ev=1&type=flv&ep=dCaUHU2LX8YJ4ivdjj8bMyqxJ3APXP8M9BiCiNRiANQnS%2B24&oip=2043219268"
#define video5 @"http://static.youku.com/v20161122.0/v/swf/player_yknpsv.swf"
#define video6 @"http://7xr82y.com1.z0.glb.clouddn.com/817F4790-65E4-4200-9341-6DC2655AD3BC.mp4"

@interface SYVideoController ()<SYVideoViewDelegate>
@property (nonatomic, strong) SYVideoView *videoView;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation SYVideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"视频";
    
    [self.view addSubview:self.videoView];
    [self.view addSubview:self.imageView];
    self.videoView.videoUrl = video1;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"截屏" style:UIBarButtonItemStylePlain target:self action:@selector(rightTapAction)];;
    self.navigationItem.rightBarButtonItem = item;
    
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.allowRotation = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.videoView pause];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.allowRotation = NO;
}

- (void)rightTapAction {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)sy_fullScreen:(BOOL)fullScreen {
    [self.navigationController setNavigationBarHidden:fullScreen animated:YES];
}

- (SYVideoView *)videoView {
    if (_videoView == nil) {
        _videoView = [[SYVideoView alloc] initWithFrame:CGRectMake(0, 64,self.view.frame.size.width , 230*self.view.frame.size.width/320)];
        _videoView.delegate = self;
    }
    return _videoView;
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.videoView.sy_bottom + 10, self.videoView.sy_width, self.videoView.sy_height)];
    }
    return _imageView;
}



- (void)dealloc {
    NSLog(@"视频消失");
}

@end
