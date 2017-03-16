//
//  RKVideoCropManager.m
//  VideoCutterDemo
//
//  Created by leju_esf on 17/3/1.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "RKVideoCropManager.h"
#import "ffmpeg.h"
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "SVProgressHUD.h"

@interface RKVideoCropManager ()<RKDoubleSliderDelegate>
@property (nonatomic, copy) NSString *inputPath;
@property (nonatomic, assign) BOOL complete;
@property (nonatomic, strong) NSURL *videoUrl;
@property (nonatomic, assign) BOOL saveComplete;
@property (nonatomic, assign) BOOL isCutting;
@end

@implementation RKVideoCropManager
- (void)setAsset:(ALAsset *)asset {
    _asset = asset;
    if (asset) {
        
        if([[NSFileManager defaultManager] fileExistsAtPath:_outputPath]) {
            [[NSFileManager defaultManager] removeItemAtPath:_outputPath error:nil];
        }
        
        if([[NSFileManager defaultManager] fileExistsAtPath:_inputPath]) {
            [[NSFileManager defaultManager] removeItemAtPath:_inputPath error:nil];
        }
        
        ALAssetRepresentation *representation = asset.defaultRepresentation;
//        long long size = representation.size;
//        NSMutableData* data = [[NSMutableData alloc] initWithCapacity:size];
//        void* buffer = [data mutableBytes];
//        [representation getBytes:buffer fromOffset:0 length:size error:nil];
//        NSData *fileData = [[NSData alloc] initWithBytes:buffer length:size];
        NSString *savePath = [NSString stringWithFormat:@"%@%@", [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/"], representation.filename];
        self.saveComplete = NO;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void)   {
            
            ALAssetRepresentation *rep = [asset defaultRepresentation];
            const char *cvideoPath = [savePath UTF8String];
            FILE *file = fopen(cvideoPath, "a+");
            if (file) {
                const int bufferSize = 111024 * 1024;
                // 初始化一个1M的buffer
                Byte *buffer = (Byte*)malloc(bufferSize);
                NSUInteger read = 0, offset = 0, written = 0;
                NSError* err = nil;
                if (rep.size != 0)
                {
                    do {
                        read = [rep getBytes:buffer fromOffset:offset length:bufferSize error:&err];
                        written = fwrite(buffer, sizeof(char), read, file);
                        offset += read;
                        
                        if (err) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                if ([self.delegate respondsToSelector:@selector(cropVideoWithProgress:outputPath:complete:error:)]) {
                                    NSError *error = [[NSError alloc] initWithDomain:@"error" code:-1 userInfo:@{@"message":@"裁剪失败"}];
                                    [self.delegate cropVideoWithProgress:self.progress outputPath:nil complete:NO error:error];
                                }
                            });
                            break;
                        }
                        if (read == 0) {
                            NSLog(@"存储完成");
                            self.saveComplete = YES;
                        }else {
                            NSLog(@"正在存储");
                        }
                        
                    } while (read != 0 && !err);
                }
                // 释放缓冲区，关闭文件
                free(buffer);
                buffer = NULL;
                fclose(file);
                file = NULL;
            
            }
            
//            BOOL write = [fileData writeToFile:savePath atomically:NO];
//            if (write == YES) {
//                NSLog(@"写入成功");
//            }else {
//                NSLog(@"写入失败");
//            }
        });
        
        _inputPath = savePath;
        _videoUrl = asset.defaultRepresentation.url;
        _outputPath = [NSString stringWithFormat:@"%@/tmp/%@", NSHomeDirectory(), representation.filename];
        _compressPath = [NSString stringWithFormat:@"%@/tmp/compress%@", NSHomeDirectory(), representation.filename];
        NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
        AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:asset.defaultRepresentation.url options:opts];
        _totalDuration = (NSInteger)(urlAsset.duration.value / urlAsset.duration.timescale);
        
        self.sliderView.maxmumValue = _totalDuration * 1.0;
        self.sliderView.secondValue = _totalDuration * 1.0;
        self.startImage = [self thumbnailImageAtTime:self.sliderView.firstValue];
        self.endImage = [self thumbnailImageAtTime:self.sliderView.secondValue];
        self.start = self.sliderView.firstValue;
        self.end = self.sliderView.secondValue;
        
        NSLog(@"时长%zd",self.totalDuration);
        
        if ([self.delegate respondsToSelector:@selector(slideViewMoved:)]) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                self.startImage = [self thumbnailImageAtTime:self.start];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate slideViewMoved:self];
                });
            });
        }
    }else {
        _inputPath = nil;
        _videoUrl = nil;
        _outputPath = nil;
    }
}

- (void)threadWillExit{
    if (self.complete) {
        [NSThread detachNewThreadSelector:@selector(compressVideo) toTarget:self withObject:nil];
        return;
    }

    self.complete = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(cropVideoWithProgress:outputPath:complete:error:)]) {
            [self.delegate cropVideoWithProgress:1.0 outputPath:self.compressPath complete:YES error:nil];
        }
    });
}

- (void)startCropVideoFrom:(NSInteger)start duration:(NSInteger)duration {
    
    if([[NSFileManager defaultManager] fileExistsAtPath:_outputPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:_outputPath error:nil];
    }

    self.start = start;
    self.end = start + duration;
    if (self.start < 0 || self.end <= self.start) {
        NSAssert(self.start < 0 || self.end <= self.start, @"开始时间错误");
        return ;
    }
    
    if (self.inputPath.length == 0) {
        NSAssert(self.inputPath.length == 0, @"输入地址不能为空");
        return ;
    }
    
    if (self.isCutting) {
        NSAssert(self.isCutting, @"正在裁剪,请稍后再试!");
        return ;
    }
    
    if (self.saveComplete) {
         [NSThread detachNewThreadSelector:@selector(startCorp) toTarget:self withObject:nil];
    }else {
        NSLog(@"还未存储完成!");
    }
}

- (void)startCorp {
    self.complete = NO;
    self.isCutting = YES;
    NSString *start = [NSString stringWithFormat:@"%.f",self.start];
    NSString *durtion = [NSString stringWithFormat:@"%.f",self.end - self.start];
    NSLog(@"裁剪时间%@------%@",start,durtion);
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(threadWillExit) name:NSThreadWillExitNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cutTimeing:) name:@"RKViedoCutProgress" object:nil];
    [self cutInputVideoPath:(char*)[self.inputPath UTF8String]  outPutVideoPath:(char*)[self.outputPath UTF8String] startTime:(char *)[start UTF8String] endTime:(char *)[durtion UTF8String]];
}

void progressCB(int time) {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RKViedoCutProgress" object:nil userInfo:@{@"currentTime":@(time)}];
}

void compressCB(int time) {
    NSLog(@"压缩时间--%d",time);
}

- (void)cutTimeing:(NSNotification *)noti {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progress = [[noti.userInfo objectForKey:@"currentTime"] integerValue] * 1.0 /(self.end - self.start);
        if ([self.delegate respondsToSelector:@selector(cropVideoWithProgress:outputPath:complete:error:)]) {
            [self.delegate cropVideoWithProgress:self.progress outputPath:self.outputPath complete:self.progress == 1.0 error:nil];
        }
    });
}

//裁剪视频函数, 命令行如下:
- (void)cutInputVideoPath:(char*)inputPath outPutVideoPath:(char*)outputPath startTime:(char*)startTime endTime:(char*)endTime {
    int numberOfArgs = 16;
    
    char** arguments = calloc(numberOfArgs, sizeof(char*));
    
    arguments[0] = "ffmpeg";
    
    arguments[1] = "-i";
    
    arguments[2] = inputPath;
    
    arguments[3] = "-ss";
    
    arguments[4] = startTime;
    
    arguments[5] = "-t";
    
    arguments[6] = endTime;
    
    arguments[7] = "-vcodec";
    
    arguments[8] = "copy";
    
    arguments[9] = "-acodec";
    
    arguments[10] = "aac";
    
    arguments[11] = "-strict";
    
    arguments[12] = "-2";
    
    arguments[13] = "-b:a";
    
    arguments[14] = "32k";
    
    arguments[15] = outputPath;
    
    int error = ffmpeg_main(numberOfArgs, arguments,progressCB);

    if (error != 1) {
        if ([self.delegate respondsToSelector:@selector(cropVideoWithProgress:outputPath:complete:error:)]) {
            NSError *error = [[NSError alloc] initWithDomain:@"error" code:-1 userInfo:@{@"message":@"裁剪失败"}];
            [self.delegate cropVideoWithProgress:self.progress outputPath:self.outputPath complete:NO error:error];
        }
    }
}

- (void)compressVideo{
    int numberOfArgs = 16;
    
    char** arguments = calloc(numberOfArgs, sizeof(char*));
    
    arguments[0] = "ffmpeg";
    
    arguments[1] = "-i";
    
    arguments[2] = (char *)[self.outputPath UTF8String];
    
    arguments[3] = "-r";
    
    arguments[4] = "10";
    
    arguments[5] = "-b:a";
    
    arguments[6] = "32k";
    
    arguments[7] = (char *)[self.compressPath UTF8String];

    int error = ffmpeg_main(numberOfArgs, arguments,compressCB);
    
    if (error == 1) {
        NSLog(@"压缩成功");
    }else {
        NSLog(@"压缩失败");
    }
}

- (UIImage*) thumbnailImageAtTime:(NSTimeInterval)time {
    
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:self.videoUrl options:nil];
        NSParameterAssert(asset);
        AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        assetImageGenerator.appliesPreferredTrackTransform = YES;
        assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
        
        CGImageRef thumbnailImageRef = NULL;
        CFTimeInterval thumbnailImageTime = time;
        NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 50) actualTime:NULL error:&thumbnailImageGenerationError];
    
        int32_t preferredTimeScale = 600;
        CMTime inTime = CMTimeMakeWithSeconds(time, preferredTimeScale);
    
        CGImageRef image = [assetImageGenerator copyCGImageAtTime:inTime actualTime:&inTime error:&thumbnailImageGenerationError];
    
        if (!thumbnailImageRef)
            NSLog(@"thumbnailImageGenerationError %@", thumbnailImageGenerationError);
        
        UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:image] : nil;
        
        return thumbnailImage;
}

- (void)startCut {
    [self startCropVideoFrom:self.start duration:self.end - self.start];
}

#pragma mark - 代理
- (void)sliderMoveActionFirstValue:(float)firstValue andSecondValue:(float)secondValue {

}

- (void)sliderEndActionFirstValue:(float)firstValue andSecondValue:(float)secondValue {
    
    if (self.start != firstValue) {
        self.start = firstValue;
        if ([self.delegate respondsToSelector:@selector(slideViewMoved:)]) {
            [self.delegate slideViewMoved:self];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                self.startImage = [self thumbnailImageAtTime:firstValue];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate slideViewMoved:self];
                });
            });
        }
    }
    
    if (self.end != secondValue) {
        self.end = secondValue;
        if ([self.delegate respondsToSelector:@selector(slideViewMoved:)]) {
            [self.delegate slideViewMoved:self];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                self.endImage = [self thumbnailImageAtTime:secondValue];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate slideViewMoved:self];
                });
            });
        }
    }
}

- (RKDoubleSlider *)sliderView {
    if (_sliderView == nil) {
        _sliderView = [[RKDoubleSlider alloc] init];
        _sliderView.delegate = self;
        _sliderView.minmumValue = 0.0;
    }
    return _sliderView;
}

- (void)dealloc {
    [[NSFileManager defaultManager] removeItemAtPath:_outputPath error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:_inputPath error:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
