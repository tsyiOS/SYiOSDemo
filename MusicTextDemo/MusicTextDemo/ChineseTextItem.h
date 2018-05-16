//
//  ChineseTextItem.h
//  MusicTextDemo
//
//  Created by leju_esf on 2018/5/11.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChineseTextItem : UIView
@property (weak, nonatomic) IBOutlet UILabel *pingyinLabel;
@property (weak, nonatomic) IBOutlet UILabel *chineseLabel;
+ (instancetype)viewFromNib;
@end
