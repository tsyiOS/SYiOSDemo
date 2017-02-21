//
//  SYGameModel.h
//  Lottery
//
//  Created by leju_esf on 17/2/21.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYGameModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *intro;
@property (nonatomic, copy) NSString *rule;
//技巧
@property (nonatomic, copy) NSString *trick;
- (instancetype)initWithDict:(NSDictionary *)dict;
+ (NSArray *)games;
@end
