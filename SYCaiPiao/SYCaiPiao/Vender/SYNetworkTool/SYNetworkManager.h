//
//  SYNetworkTool.h
//  SYCaiPiao
//
//  Created by leju_esf on 17/5/9.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYNetworkManager : AFHTTPSessionManager
+ (instancetype)shareManager;
- (void)requestHomeDataCompletion:(void (^)())completion;
@end
