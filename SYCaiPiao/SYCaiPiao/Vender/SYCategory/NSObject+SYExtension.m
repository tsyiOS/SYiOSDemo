//
//  NSObject+SYExtension.m
//
//  Created by 唐绍禹 on 16/8/10.
//  Copyright © 2016年 tsy. All rights reserved.
//

#import "NSObject+SYExtension.h"
#import <objc/runtime.h>
#import <CoreData/CoreData.h>

static NSSet *foundationClasses_;

@implementation NSObject (SYExtension)
- (id)sy_keyValues {
    if ([[self class] sy_isClassFromFoundation]) {
        return self;
    }
    //数组
    if ([self isKindOfClass:[NSArray class]]) {
        NSArray *array = (NSArray *)self;
        NSMutableArray *tempArray = [NSMutableArray array];
        for (id value in array) {
            [tempArray addObject:[value sy_keyValues]];
        }
        return tempArray;
    }
    //对象
    NSArray *keys = [[self class] sy_propertyList];
    NSMutableDictionary *keyValues = [NSMutableDictionary dictionary];
    for (NSString *key in keys) {
        id value = [self valueForKey:key];
        //如何在此处崩溃，请查看属性修饰是否正确
        if ([[value class] sy_isClassFromFoundation]) {
            [keyValues setValue:value forKey:key];
        }else {
            [keyValues setValue: [value sy_keyValues] forKey:key];
        }
    }
    [keyValues setValue:NSStringFromClass([self class]) forKey:sy_keyForClassName];
    return keyValues;
}

+ (instancetype)sy_objectWithKeyValueDictionary:(NSDictionary *)keyValues {
    id model = [[self alloc] init];
    for (NSString *key in [self sy_propertyList]) {
        if (![keyValues.allKeys containsObject:key]) {
            continue;
        }
        id value = keyValues[key];
        if ([value isKindOfClass:[NSDictionary class]]) {
            Class c = NSClassFromString(value[sy_keyForClassName]);
            if ([value objectForKey:sy_keyForClassName]) {
                id propretyModel = [c sy_objectWithKeyValueDictionary:value];
                [model setValue:propretyModel forKey:key];
            }else {
                if ([[self sy_classNameForPropertyObject] objectForKey:key]) {
                     Class className = NSClassFromString([[self sy_classNameForPropertyObject] objectForKey:key]);
                    id propretyModel = [className sy_objectWithKeyValueDictionary:value];
                    [model setValue:propretyModel forKey:key];
                }else {
                    [model setValue:nil forKey:key];
                }
            }
            
        }else if ([value isKindOfClass:[NSArray class]]) {
            NSArray *valueArray = (NSArray *)value;
            [model setValue:[self sy_objectsWithArray:valueArray andKey:key] forKey:key];
        }else {
             [model setValue:value forKey:key];
        }
    }
    return model;
}

+ (NSArray *)sy_objectArrayWithPlist:(NSString *)plist {
    NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",plist] ofType:@"plist"];
    NSArray *dicts = [NSArray arrayWithContentsOfFile:path];
    if (dicts.count > 0) {
        return [self sy_objectArrayWithKeyValueArray:dicts];
    }else {
        return nil;
    }
}

+ (NSArray *)sy_objectArrayWithKeyValueArray:(NSArray *)dicts {
    if (dicts.count == 0) {
        return nil;
    }
    if ([dicts isKindOfClass:[NSArray class]]) {
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSDictionary *dict in dicts) {
            id model = [self sy_objectWithKeyValueDictionary:dict];
            [tempArray addObject:model];
        }
        return tempArray;
    }else{
        return dicts;
    }
}

+ (NSArray *)sy_objectsWithArray:(NSArray *)array andKey:(NSString *)key {
    NSDictionary *dict = [self sy_classNameInArrayProperty];
    NSString *className = [dict objectForKey:key];
    NSMutableArray *tempArray = [NSMutableArray array];
    if (className.length > 0) {
        for (NSDictionary *keyValues in array) {
            Class c = NSClassFromString(className);
            id propretyModel = [c sy_objectWithKeyValueDictionary:keyValues];
            [tempArray addObject:propretyModel];
        }
        return tempArray;
    }else {
        return nil;
    }
}

+ (NSDictionary *)sy_classNameInArrayProperty{
    return nil;
}

+ (NSDictionary *)sy_classNameForPropertyObject {
    return nil;
}

- (id)sy_objectWithKeyValue {
    if ([self isKindOfClass:[NSDictionary class]]) {
        NSDictionary *keyValue = (NSDictionary *)self;
        Class c = NSClassFromString(keyValue[sy_keyForClassName]);
        return [c sy_objectWithKeyValueDictionary:keyValue];
    }else {
        return nil;
    }
    
}

+ (NSArray *)sy_propertyList {
    Class c = self;
    NSMutableArray *tempArray = [NSMutableArray array];
    while (c && c != [NSObject class]) {
        unsigned int count = 0;
        Ivar *ivar = class_copyIvarList(c, &count);
        for (int i = 0; i<count; i++) {
            Ivar iva = ivar[i];
            const char *name = ivar_getName(iva);
            NSString *strName = [NSString stringWithUTF8String:name];
            [tempArray addObject:[strName substringFromIndex:1]];
        }
        free(ivar);
        c = [c superclass];
    }
    return tempArray.copy;
}

+ (NSSet *)sy_foundationClasses {
    if (foundationClasses_ == nil) {
        // 集合中没有NSObject，因为几乎所有的类都是继承自NSObject，具体是不是NSObject需要特殊判断
        foundationClasses_ = [NSSet setWithObjects:
                              [NSURL class],
                              [NSDate class],
                              [NSValue class],
                              [NSData class],
                              [NSError class],
//                              [NSArray class],
                              [NSDictionary class],
                              [NSString class],
                              [NSAttributedString class], nil];
    }
    return foundationClasses_;
}

+ (BOOL)sy_isClassFromFoundation {
    if (self == [NSObject class] || self == [NSManagedObject class]) return YES;
    
    __block BOOL result = NO;
    [[self sy_foundationClasses] enumerateObjectsUsingBlock:^(Class foundationClass, BOOL *stop) {
        if ([self isSubclassOfClass:foundationClass]) {
            result = YES;
            *stop = YES;
        }
    }];
    return result;
}
@end

NSString *const sy_keyForClassName = @"keyForClassName";
