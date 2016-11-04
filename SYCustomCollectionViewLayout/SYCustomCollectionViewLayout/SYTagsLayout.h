//
//  SYTagsLayout.h
//  SYCustomCollectionViewLayout
//
//  Created by leju_esf on 16/11/4.
//  Copyright © 2016年 tsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYTagsLayout : UICollectionViewFlowLayout
/**
 *  文字数组
 */
@property (nonatomic, strong) NSArray <NSString *>*datas;
/**
 *  每个item文字内容的四周的边距 默认UIEdgeInsetsMake(10, 15, 10, 15)
 */
@property (nonatomic, assign) UIEdgeInsets itemContentInsets;
/**
 *  文字大小  默认[UIFont systemFontOfSize:12]
 */
@property (nonatomic, strong) UIFont *textFont;
@end
