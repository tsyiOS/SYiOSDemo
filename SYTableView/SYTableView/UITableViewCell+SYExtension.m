//
//  UITableViewCell+SYExtension.m
//  SYTableView
//
//  Created by leju_esf on 2017/6/16.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import "UITableViewCell+SYExtension.h"
#import <objc/runtime.h>

@implementation UITableViewCell (SYExtension)
@dynamic sy_JsonDict,sy_cellBlock;
static const char SY_JsonDictKey = '\4';
static const char SY_CellBlockKey = '\5';

- (void)setSy_cellBlock:(void (^)(NSDictionary *sy_JsonDict))sy_cellBlock {
    objc_setAssociatedObject(self, &SY_CellBlockKey, sy_cellBlock, OBJC_ASSOCIATION_COPY);
}

- (void)cacheJsonDict:(NSDictionary *)sy_JsonDict {
    objc_setAssociatedObject(self, &SY_JsonDictKey, sy_JsonDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDictionary *)sy_JsonDict {
    return objc_getAssociatedObject(self, &SY_JsonDictKey);
}

- (void (^)(NSDictionary *))sy_cellBlock {
     return objc_getAssociatedObject(self, &SY_CellBlockKey);
}

@end
