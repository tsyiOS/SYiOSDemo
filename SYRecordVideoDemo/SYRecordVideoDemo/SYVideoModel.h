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
- (NSString *)takeDate;
+ (void)saveVideo:(SYVideoModel *)video;
+ (NSArray *)videoList;
- (UIImage*) thumbnailImageAtTime:(NSTimeInterval)time;
@end
