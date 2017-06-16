//
//  SYTableView.h
//  SYTableView
//
//  Created by leju_esf on 2017/6/15.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYTableView : UITableView
@property (nonatomic, copy) void(^requestData)(NSInteger page);
@end
