//
//  SYVideoModel.h
//  SYRecordVideoDemo
//
//  Created by leju_esf on 17/3/16.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYVideoModel : NSObject
@property (nonatomic, copy) NSString *path;
@property (nonatomic, assign) CGFloat totalTime;
@property (nonatomic, strong) UIImage *defaultImage;
@property (nonatomic, assign) NSString *sizeStr;
@property (nonatomic, assign) long long size;
- (void)sy_setImage:(void (^)(UIImage *image))block;
- (NSString *)takeDate;
- (UIImage*) thumbnailImageAtTime:(NSTimeInterval)time;
/**
 保存视频

 @param video 视频
 */
+ (void)saveVideo:(SYVideoModel *)video;
/**
 删除视频

 @param video 视频
 @return 删除后的数组
 */
+ (NSArray *)removeVideo:(SYVideoModel *)video;
+ (NSArray *)videoList;

@end
