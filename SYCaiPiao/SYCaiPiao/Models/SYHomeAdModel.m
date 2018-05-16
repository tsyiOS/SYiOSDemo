//
//  SYHomeAdModel.m
//  SYCaiPiao
//
//  Created by leju_esf on 17/5/9.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import "SYHomeAdModel.h"

@implementation SYHomeAdModel
+ (NSArray *)models {
    return [self mj_objectArrayWithFile:@"AdList.plist"];
}
@end
