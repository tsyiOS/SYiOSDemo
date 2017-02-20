//
//  SYTagsLayout.m
//  SYCustomCollectionViewLayout
//
//  Created by leju_esf on 16/11/4.
//  Copyright © 2016年 tsy. All rights reserved.
//

#import "SYTagsLayout.h"

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height

@interface SYTagsLayout ()
@property (nonatomic, strong) NSArray *attributes;
@end

@implementation SYTagsLayout
- (instancetype)init {
    if (self = [super init]) {
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        _itemContentInsets = UIEdgeInsetsMake(10, 15, 10, 15);
        _textFont = [UIFont systemFontOfSize:12];
    }
    return self;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    NSLog(@"=====%@",NSStringFromCGRect(newBounds));
    return NO;
}

- (void)prepareLayout {
    [super prepareLayout];
}

- (CGSize)collectionViewContentSize {
    if  (self.attributes.count > 0) {
        UICollectionViewLayoutAttributes *attrs = self.attributes.lastObject;
        return CGSizeMake(self.collectionView.frame.size.width - self.collectionView.contentInset.left - self.collectionView.contentInset.right, attrs.frame.origin.y + attrs.frame.size.height + self.sectionInset.bottom);
    }else {
        return  CGSizeMake(self.collectionView.frame.size.width - self.collectionView.contentInset.left - self.collectionView.contentInset.right, [self caltulatorAttrbutes]);
    }
}

- (void)setDatas:(NSArray *)datas {
    _datas = datas;
    [self caltulatorAttrbutes];
    [self.collectionView reloadData];
}

- (CGFloat)caltulatorAttrbutes {
    if (self.collectionView == nil) {
        return 0;
    }
    CGFloat totalHeight = 0;
    CGRect previousFrame = CGRectZero;

    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0;i<self.datas.count;i++) {
        NSString *text = self.datas[i];
        CGSize textSize = [text sizeWithAttributes:@{NSFontAttributeName:self.textFont}];
        
        textSize.width += self.itemContentInsets.left + self.itemContentInsets.right;
        textSize.height += self.itemContentInsets.top + self.itemContentInsets.bottom;
        
        //单个item最长为一行
        textSize.width = MIN(textSize.width, self.collectionView.frame.size.width - self.sectionInset.left - self.sectionInset.right-self.collectionView.contentInset.left - self.collectionView.contentInset.right);
        
        UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        
        if (i == 0) {
            CGRect frame = CGRectMake(self.sectionInset.left, self.sectionInset.top + self.collectionView.contentInset.top, textSize.width, textSize.height);
            totalHeight = textSize.height;
            previousFrame = frame;
        } else {
            CGRect newRect = CGRectZero;
            if (previousFrame.origin.x + previousFrame.size.width + textSize.width + self.minimumInteritemSpacing > self.collectionView.frame.size.width - self.sectionInset.right -self.collectionView.contentInset.left - self.collectionView.contentInset.right) {
                newRect.origin = CGPointMake(self.sectionInset.left, previousFrame.origin.y + textSize.height + self.minimumLineSpacing);
                totalHeight += textSize.height + self.minimumLineSpacing;
            } else {
                newRect.origin = CGPointMake(previousFrame.origin.x + previousFrame.size.width + self.minimumInteritemSpacing, previousFrame.origin.y);
            }
            newRect.size = textSize;
            previousFrame = newRect;
        }
        
        attrs.frame = previousFrame;
        [tempArray addObject:attrs];
    }
    self.attributes = tempArray;
    return totalHeight + self.sectionInset.bottom + self.collectionView.contentInset.bottom;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attributes;
}

@end
