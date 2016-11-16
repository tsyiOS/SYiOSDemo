//
//  SYListViewController.h
//  SYHtml
//
//  Created by leju_esf on 16/11/16.
//  Copyright © 2016年 tsy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYHtmlManager.h"

@interface SYListViewController : UITableViewController
@property (nonatomic, assign) SYHtmlType type;
@property (nonatomic, copy) NSString *urlSring;
@end
