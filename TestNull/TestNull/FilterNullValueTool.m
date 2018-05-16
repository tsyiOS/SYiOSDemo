//
//  FilterNullValueTool.m
//  TestNull
//
//  Created by leju_esf on 2017/12/4.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import "FilterNullValueTool.h"

@implementation FilterNullValueTool
+ (NSDictionary *)dictionaryFilterNullValue:(NSDictionary *)dict {
    if ([dict isKindOfClass:[NSDictionary class]] && dict.count > 0) {
        NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:dict];
        [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[NSArray class]]) {
                [result setObject:[self arrayFilterNullValue:obj] forKey:key];
            }
            
            if ([obj isKindOfClass:[NSDictionary class]]) {
                [result setObject:[self dictionaryFilterNullValue:obj] forKey:key];
            }
            
            if ([obj isKindOfClass: [NSNull class]]) {
                [result setObject:@"" forKey:key];
            }
        }];
        return result;
    }
    return @{};
}
+ (NSArray *)arrayFilterNullValue:(NSArray *)array {
    if ([array isKindOfClass:[NSArray class]] && array.count > 0) {
        NSMutableArray *result = [NSMutableArray arrayWithArray:array];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                [result replaceObjectAtIndex:idx withObject:[self dictionaryFilterNullValue:obj]];
            }
            
            if ([obj isKindOfClass:[NSArray class]]) {
                [result replaceObjectAtIndex:idx withObject:[self arrayFilterNullValue:obj]];
            }
            
            if ([obj isKindOfClass: [NSNull class]]) {
                [result replaceObjectAtIndex:idx withObject:@""];
            }
        }];
        return result;
    }
    return @[];
}
@end
