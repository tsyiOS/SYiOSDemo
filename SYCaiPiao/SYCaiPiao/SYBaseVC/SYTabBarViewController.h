//
//  SYTabBarViewController.h
//  SYCaiPiao
//
//  Created by leju_esf on 17/5/5.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYChildVCModel : NSObject
@property (nonatomic, copy) NSString *className;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *selectedImageName;
+ (NSArray *)models;
@end

@interface SYTabBarViewController : UITabBarController

@end
