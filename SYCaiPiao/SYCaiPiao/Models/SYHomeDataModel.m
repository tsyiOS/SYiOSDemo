//
//  SYHomeDataModel.m
//  SYCaiPiao
//
//  Created by leju_esf on 17/5/9.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import "SYHomeDataModel.h"

@implementation SYHomeDataModel
+ (NSArray *)models {
    return [self sy_objectArrayWithPlist:@"HomeList"];
}

+ (NSDictionary *)sy_classNameForPropertyObject {
    return  @{
                      @"attribute":@"SYHomeDataInforModel"
                      };
}

@end

@implementation SYHomeDataInforModel



@end
