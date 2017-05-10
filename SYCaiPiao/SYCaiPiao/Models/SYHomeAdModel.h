//
//  SYHomeAdModel.h
//  SYCaiPiao
//
//  Created by leju_esf on 17/5/9.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYHomeAdModel : NSObject
@property (nonatomic, copy) NSString *clickHref;
@property (nonatomic, copy) NSString *picture;
+ (NSArray *)models;
@end
