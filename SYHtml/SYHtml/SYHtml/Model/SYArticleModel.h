//
//  SYArticleModel.h
//  SYHtml
//
//  Created by leju_esf on 16/11/16.
//  Copyright © 2016年 tsy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYCoder.h"

@interface SYArticleModel : NSObject
SYStorageByArchive_interface(SYArticleModel)
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *title;
@end
