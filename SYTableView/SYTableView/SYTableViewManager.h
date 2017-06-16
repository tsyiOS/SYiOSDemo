//
//  SYTableViewManager.h
//  SYTableView
//
//  Created by leju_esf on 2017/6/15.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SYTableViewManager : NSObject
@property (nonatomic, strong) Class cellClass;
@property (nonatomic, copy) void(^selectedCellAction)(NSIndexPath *indexPath,NSDictionary *jsonDict);
@property (nonatomic, copy) void(^cellBlock)(NSIndexPath *indexPath,NSDictionary *jsonDict);
@property (nonatomic, strong) UITableView *tableView;
- (void)setRequestNetwork:(void (^)(NSInteger page,void (^completion)(NSArray *datas)))requestData;
@end
