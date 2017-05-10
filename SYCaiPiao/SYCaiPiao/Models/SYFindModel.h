//
//  SYFindModel.h
//  SYCaiPiao
//
//  Created by leju_esf on 17/5/10.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYFindModel : NSObject
@property (nonatomic, copy) NSString *descript;
@property (nonatomic, assign) BOOL groupFlag;
@property (nonatomic, copy) NSString *jumpUrl;
@property (nonatomic, copy) NSString *logoUrl;
@property (nonatomic, assign) BOOL showAlert;
@property (nonatomic, copy) NSString *showAlertTime;
@property (nonatomic, copy) NSString *title;
+ (NSArray *)models;
@end
