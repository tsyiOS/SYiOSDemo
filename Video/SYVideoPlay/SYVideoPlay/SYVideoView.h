//
//  SYVideoView.h
//  SYVideoPlay
//
//  Created by leju_esf on 16/11/21.
//  Copyright © 2016年 tsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYVideoView : UIView
@property (nonatomic, copy) NSString *videoUrl;
- (void)play;
- (void)pause;
@end
