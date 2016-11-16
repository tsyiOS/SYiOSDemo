//
//  SYHtmlManager.h
//  SYHtml
//
//  Created by leju_esf on 16/11/15.
//  Copyright © 2016年 tsy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYCoder.h"

typedef NS_ENUM(NSUInteger, SYHtmlType) {
    SYHtmlTypeAllList,
    SYHtmlTypeArticleList,
    SYHtmlTypeArticle,
    SYHtmlTypePictureList,
    SYHtmlTypePicture
};

@interface SYHtmlManager : NSObject
SYSingleton_interface(SYHtmlManager)

- (void)requestDataWithUrl:(NSString *)urlString andType:(SYHtmlType)type completion:(void(^)(id response))completion;
@end
