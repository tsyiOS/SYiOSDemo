//
//  FilterNullValueTool.h
//  TestNull
//
//  Created by leju_esf on 2017/12/4.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilterNullValueTool : NSObject
+ (NSDictionary *)dictionaryFilterNullValue:(NSDictionary *)dict;
+ (NSArray *)arrayFilterNullValue:(NSArray *)array;
@end
