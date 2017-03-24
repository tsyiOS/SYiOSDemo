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
@property (weak, nonatomic) IBOutlet UISwitch *soundSwitch;
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
    if (progress >= 1) {
        [self cutOutRecord];
    }
}
- (IBAction)switchAction:(UISwitch *)sender {
    self.recordEngine.isSoundOff = sender.isOn;
}

- (IBAction)backAction {
    __weak typeof(self) weakSelf = self;
    if (self.recordEngine.isCapturing) {
        [self.recordEngine stopCaptureHandler:^(CGFloat totalTime) {
            [weakSelf saveVideoWithTotalTime:totalTime];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
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

- (void)cutOutRecord {
    if (_recordEngine.videoPath.length > 0) {
        self.startBtn.selected = NO;
         __weak typeof(self) weakSelf = self;
        [self.recordEngine stopCaptureHandler:^(CGFloat totalTime) {
            [weakSelf saveVideoWithTotalTime:totalTime];
            [weakSelf startRecord:self.startBtn];
            NSLog(@"保存一条数据");
        }];
    }else {
        NSLog(@"请先录制视频~");
    }
}

- (void)saveVideoWithTotalTime:(CGFloat)totalTime {
    SYVideoModel *model = [[SYVideoModel alloc] init];
    model.path = _recordEngine.videoPath;
    model.totalTime = totalTime;
    [SYVideoModel saveVideo:model];
    _recordEngine.videoPath = nil;
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
