//
//  SYCardLayout.m
//  SYCardScroll
//
//  Created by leju_esf on 2017/7/17.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import "SYCardLayout.h"

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height

@interface SYCardLayout ()
@property (nonatomic, strong) NSArray *attributes;
@end

@implementation SYCardLayout

- (instancetype)init {
    if (self = [super init]) {
        
    }
    
    return self;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return NO;
}

- (void)setCount:(NSInteger)count {
    _count = count;
    if (self.collectionView == nil) {
        return;
    }
    CGFloat totalHeight = 0;
    NSMutableArray *tempArray = [NSMutableArray array];
    
}

@end
