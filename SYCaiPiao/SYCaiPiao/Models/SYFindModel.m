//
//  SYFindModel.m
//  SYCaiPiao
//
//  Created by leju_esf on 17/5/10.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import "SYFindModel.h"

@implementation SYFindModel
+ (NSArray *)models {
    return [self mj_objectArrayWithFile:@"Find.plist"];
}
@end
