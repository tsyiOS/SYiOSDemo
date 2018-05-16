//
//  MusicTextCell.h
//  MusicTextDemo
//
//  Created by leju_esf on 2018/5/11.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ItemHeight 70

@interface MusicTextCell : UITableViewCell
@property (nonatomic, strong) NSArray *pingyins;
@property (nonatomic, strong) NSArray *chineses;
@property (nonatomic, assign) CGFloat scale;
@end
