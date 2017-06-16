//
//  UITableViewCell+SYExtension.h
//  SYTableView
//
//  Created by leju_esf on 2017/6/16.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (SYExtension)
@property (nonatomic, strong) NSDictionary *sy_JsonDict;
@property (nonatomic, copy) void(^sy_cellBlock)(NSDictionary *sy_JsonDict);
- (void)cacheJsonDict:(NSDictionary *)sy_JsonDict;
@end
