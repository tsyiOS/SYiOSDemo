//
//  SYHomeDataModel.h
//  SYCaiPiao
//
//  Created by leju_esf on 17/5/9.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYHomeDataInforModel : NSObject
@property (nonatomic, copy) NSString *cardDesc;
@property (nonatomic, copy) NSString *cardName;
@property (nonatomic, copy) NSString *jumpUrl;
@property (nonatomic, copy) NSString *logo;
@property (nonatomic, assign) NSInteger rankMax;
@property (nonatomic, assign) NSInteger rankMin;
@end

@interface SYHomeDataModel : NSObject
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) SYHomeDataInforModel *attribute;
+ (NSArray *)models;
@end
