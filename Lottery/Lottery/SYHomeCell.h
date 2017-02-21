//
//  SYHomeCell.h
//  Lottery
//
//  Created by leju_esf on 17/2/20.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYGameModel.h"
@interface SYHomeCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) SYGameModel *model;
@end
