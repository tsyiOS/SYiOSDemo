//
//  SYTextModel.m
//  InterviewSource
//
//  Created by leju_esf on 16/11/29.
//  Copyright © 2016年 tsy. All rights reserved.
//

#import "SYTextModel.h"

@implementation SYTextModel
- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)textWithDict:(NSDictionary *)dict {
    return  [[self alloc] initWithDict:dict];
}

+ (NSArray *)texts {
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"text" ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSArray *textArray in array) {
        NSMutableArray *dictArray = [NSMutableArray array];
        for (NSDictionary *dict in textArray) {
            SYTextModel *text = [SYTextModel textWithDict:dict];
            [dictArray addObject:text];
        }
        [tempArray addObject:dictArray];
    }
    return tempArray;
}
@end
