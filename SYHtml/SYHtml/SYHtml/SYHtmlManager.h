//
//  SYHtmlManager.h
//  SYHtml
//
//  Created by leju_esf on 16/11/15.
//  Copyright © 2016年 tsy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYCoder.h"

@interface SYHtmlManager : NSObject
SYSingleton_interface(SYHtmlManager)
- (void)requestData;
@end
