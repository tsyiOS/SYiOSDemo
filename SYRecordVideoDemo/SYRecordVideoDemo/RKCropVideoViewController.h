//
//  RKCropVideoViewController.h
//  SYRecordVideoDemo
//
//  Created by leju_esf on 17/3/23.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RKCropVideoViewController : UIViewController
@property (nonatomic, strong) NSString *path;
/**
 视频的最大长度
 */
@property (nonatomic, assign) double maxTime;
/**
 视频的最小长度 
 */
@property (nonatomic, assign) double minTime;
@end
