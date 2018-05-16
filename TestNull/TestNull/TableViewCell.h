//
//  TableViewCell.h
//  TestNull
//
//  Created by leju_esf on 2017/12/5.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell
@property (nonatomic, strong) NSDictionary *dict;
@property (nonatomic, copy) void(^clickswitch)(BOOL on);
@end
