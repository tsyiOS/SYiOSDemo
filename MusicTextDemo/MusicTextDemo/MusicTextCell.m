//
//  MusicTextCell.m
//  MusicTextDemo
//
//  Created by leju_esf on 2018/5/11.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import "MusicTextCell.h"
#import "ChineseTextItem.h"

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height

#define MaxFont 18
#define MinFont 12
#define LineNumber 8

#define BaseTag 100

@implementation MusicTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    CGFloat w = ScreenW/LineNumber;
    for (int i = 0; i < LineNumber; i++) {
        ChineseTextItem *item = [ChineseTextItem viewFromNib];
        item.chineseLabel.font = [UIFont systemFontOfSize:MinFont];
        item.pingyinLabel.font = [UIFont systemFontOfSize:MinFont];
        item.frame = CGRectMake(i * w, 0, w, ItemHeight);
        item.tag = i + BaseTag;
        [self.contentView addSubview:item];
    }
}

- (void)setChineses:(NSArray *)chineses {
    _chineses = chineses;
    for (int i = 0; i < LineNumber; i++) {
        ChineseTextItem *item = [self.contentView viewWithTag:i + BaseTag];
        if (i < chineses.count) {
            item.chineseLabel.text = chineses[i];
            item.pingyinLabel.text = self.pingyins[i];
        }else {
            item.chineseLabel.text = nil;
            item.pingyinLabel.text = nil;
        }
    }
}

- (void)setScale:(CGFloat)scale {
    _scale = scale;
    for (int i = 0; i < LineNumber; i++) {
        ChineseTextItem *item = [self.contentView viewWithTag:i + BaseTag];
        item.chineseLabel.font = [UIFont systemFontOfSize:(MaxFont - MinFont) * scale + MinFont];
        item.pingyinLabel.font = [UIFont systemFontOfSize:(MaxFont - MinFont) * scale + MinFont];
    }
}
@end
