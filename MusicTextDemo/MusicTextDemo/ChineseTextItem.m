//
//  ChineseTextItem.m
//  MusicTextDemo
//
//  Created by leju_esf on 2018/5/11.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import "ChineseTextItem.h"

@implementation ChineseTextItem

+ (instancetype)viewFromNib{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil].firstObject;
}

@end
