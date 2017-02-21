//
//  SYGameModel.m
//  Lottery
//
//  Created by leju_esf on 17/2/21.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import "SYGameModel.h"

@implementation SYGameModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (NSArray *)games {
    NSArray *dicts = [NSArray arrayWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"gameData" ofType:@".plist"]];
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSDictionary *dict in dicts) {
        SYGameModel *model =[[SYGameModel alloc] initWithDict:dict];
        [tempArray addObject:model];
    }
    return tempArray;
}
@end
