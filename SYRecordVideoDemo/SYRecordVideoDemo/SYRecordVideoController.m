//
//  SYRecordVideoController.m
//  SYRecordVideoDemo
//
//  Created by leju_esf on 17/3/15.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import "SYRecordVideoController.h"
#import "WCLRecordEngine.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>
#import "SYVideoModel.h"

@interface SYRecordVideoController ()<WCLRecordEngineDelegate>
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (strong, nonatomic) WCLRecordEngine *recordEngine;
@end

@implementation SYRecordVideoController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.recordEngine shutdown];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.recordEngine startUp];
    
}

- (void)recordProgress:(CGFloat)progress {
    NSLog(@"录制进度-----%f",progress);
}

- (IBAction)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)startRecord:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        if (self.recordEngine.isCapturing) {
            [self.recordEngine resumeCapture];
        }else {
            [self.recordEngine startCapture];
        }
    }else {
        [self.recordEngine pauseCapture];
    }
}
- (IBAction)stopRecord {
    if (_recordEngine.videoPath.length > 0) {
        self.startBtn.selected = NO;
        [self.recordEngine stopCaptureHandler:^(CGFloat totalTime) {
            NSLog(@"url==%@---%f",_recordEngine.videoPath,totalTime);
            SYVideoModel *model = [[SYVideoModel alloc] init];
            model.path = _recordEngine.videoPath;
            model.totalTime = totalTime;
            [SYVideoModel saveVideo:model];
            _recordEngine.videoPath = nil;
        }];
    }else {
        NSLog(@"请先录制视频~");
    }
}

- (WCLRecordEngine *)recordEngine {
    if (_recordEngine == nil) {
        _recordEngine = [[WCLRecordEngine alloc] init];
        _recordEngine.delegate = self;
        _recordEngine.previewLayer.frame = [UIScreen mainScreen].bounds;
        [self.view.layer insertSublayer:_recordEngine.previewLayer atIndex:0];
    }
    return _recordEngine;
}


@end
