//
//  SYTextModel.h
//  InterviewSource
//
//  Created by leju_esf on 16/11/29.
//  Copyright © 2016年 tsy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYTextModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *type;
+ (NSArray *)texts;
@end
