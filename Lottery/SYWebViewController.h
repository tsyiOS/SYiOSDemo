//
//  SYWebViewController.h
//  Lottery
//
//  Created by leju_esf on 17/2/20.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYGameModel.h"

#define kIsLoadUrl @"kIsLoadUrl"
#define kUserInformation @"kUserInformation"

@interface SYWebViewController : UIViewController
@property (nonatomic, strong) SYGameModel *model;
@end
