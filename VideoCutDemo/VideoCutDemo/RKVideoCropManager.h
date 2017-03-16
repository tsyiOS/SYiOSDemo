//
//  RKVideoCropManager.h
//  VideoCutterDemo
//
//  Created by leju_esf on 17/3/1.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "RKDoubleSlider.h"

@class RKVideoCropManager;

@protocol RKVideoCropManagerDelegate <NSObject>

@optional
/**
 完成裁剪视频后的回调

 @param outputPath 回调地址
 */
- (void)cropVideoWithProgress:(CGFloat)progress outputPath:(NSString *)outputPath complete:(BOOL)complete error:(NSError *)error;

/**
 滑动滑竿时候的回调

 @param manager 裁剪对象
 */
- (void)slideViewMoved:(RKVideoCropManager *)manager;
@end

@interface RKVideoCropManager : NSObject
/**
 文件路径
 */
@property (nonatomic, copy) NSString *outputPath;
@property (nonatomic, copy) NSString *compressPath;
/**
 开始截取时间
 */
@property (nonatomic, assign) float start;
/**
 结束截取时间
 */
@property (nonatomic, assign) float end;
/**
 开始截取点截图
 */
@property (nonatomic, strong) UIImage *startImage;
/**
 结束截取点截图
 */
@property (nonatomic, strong) UIImage *endImage;
/**
 总时长  单位 s
 */
@property (nonatomic, assign) NSInteger totalDuration;
/**
 剪切的进度  
 */
@property (nonatomic, assign) float progress;
/**
 媒体资源
 */
@property (nonatomic, strong) ALAsset *asset;
/**
 代理
 */
@property (nonatomic, weak) id<RKVideoCropManagerDelegate> delegate;
/**
 选择滑竿
 */
@property (nonatomic, strong) RKDoubleSlider *sliderView;
/**
 开始裁剪
 */
- (void)startCropVideoFrom:(NSInteger)start duration:(NSInteger)duration;
/**
 开始裁剪
 */
- (void)startCut;
/**
 获取缩略图

 @param time 时间
 @return 缩略图
 */
- (UIImage*) thumbnailImageAtTime:(NSTimeInterval)time;
@end
