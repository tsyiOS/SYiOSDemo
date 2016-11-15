//
//  RPEvaluateModel.h
//  SYModel
//
//  Created by leju_esf on 16/11/10.
//  Copyright © 2016年 tsy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RPEvaluateTag,RPEvaluateModel,RPEvaluateLevel;
@interface RPEvaluateListModel : NSObject

@property (nonatomic, copy) NSString *avgmark;

@property (nonatomic, strong) NSArray<RPEvaluateModel *> *list;

@property (nonatomic, strong) NSArray<RPEvaluateTag *> *tagsinfo;

@property (nonatomic, strong) RPEvaluateLevel *highCount;

@property (nonatomic, strong) RPEvaluateLevel *middleCount;

@property (nonatomic, strong) RPEvaluateLevel *lowCount;

@property (nonatomic, copy) NSString *row_count;

@property (nonatomic, copy) NSString *page_count;

@end

@interface RPEvaluateLevel : NSObject

@property (nonatomic, copy) NSString *key;

@property (nonatomic, copy) NSString *value;

@end

@interface RPEvaluateTag : NSObject

@property (nonatomic, copy) NSString *tag_count;

@property (nonatomic, copy) NSString *tag_name;

@property (nonatomic, copy) NSString *tag_id;

@end

@interface RPEvaluateModel : NSObject

@property (nonatomic, strong) NSArray<NSString *> *picurl;

@property (nonatomic, copy) NSString *thumbs;

@property (nonatomic, copy) NSString *photourl;

@property (nonatomic, copy) NSString *mark;

@property (nonatomic, copy) NSString *uuid;

@property (nonatomic, copy) NSString *cdate;

@property (nonatomic, copy) NSString *description;

@property (nonatomic, strong) NSArray<NSString *> *tags;

@property (nonatomic, copy) NSString *user;

@end

