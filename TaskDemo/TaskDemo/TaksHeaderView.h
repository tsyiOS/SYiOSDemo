//
//  TaksHeaderView.h
//  TaskDemo
//
//  Created by leju_esf on 2018/4/19.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaksHeaderView : UITableViewHeaderFooterView
@property (nonatomic, copy) void(^openAction)();
@end
