//
//  UITableView+SYSlideExtension.h
//  SYSlideDemo
//
//  Created by 唐绍禹 on 16/9/20.
//  Copyright © 2016年 tsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (SYSlideExtension)
@property (nonatomic, copy) void (^sy_headerRefresh)();
- (void)sy_beginRefresh;
- (void)sy_endRefresh;
- (void)sy_observeTableViewContentOffset;
@end
