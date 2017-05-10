//
//  SYCityModel.m
//  SYCaiPiao
//
//  Created by leju_esf on 17/5/8.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import "SYCityModel.h"

@implementation SYProvinceModel

+ (NSDictionary *)sy_classNameInArrayProperty {
    return @{@"citys":@"SYCityModel"};
}

+ (NSArray *)provinces {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"citys" ofType:@"plist"];
    NSArray *provinces = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSDictionary *dict in provinces) {
        SYProvinceModel *model = [SYProvinceModel sy_objectWithKeyValueDictionary:dict];
        [tempArray addObject:model];
    }
    return tempArray;
}

@end

@implementation SYCityModel
+ (NSDictionary *)sy_classNameInArrayProperty {
    return @{@"areas":@"SYAreaModel"};
}
@end

@implementation SYAreaModel



@end
