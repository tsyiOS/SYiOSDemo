//
//  SYNetworkTool.m
//  SYCaiPiao
//
//  Created by leju_esf on 17/5/9.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import "SYNetworkManager.h"

@implementation SYNetworkManager
+ (instancetype)shareManager {
    static SYNetworkManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self class] manager];
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObjectsFromArray:@[@"text/html", @"text/plain"]];
    });
    return manager;
}

- (void)requestHomeDataCompletion:(void (^)())completion {
    
    NSDictionary *parameters = @{
                                 @"product":@"lede_cp",
                                 @"mobileType":@"iphone",
                                 @"ver":@"2.15",
                                 @"channel":@"lede",
                                 @"apiVer":@"1.1",
                                 @"apiLevel":@"27",
                                 @"deviceId":@"3629496C-F957-4DFC-8D7D-1D990ED7F2E0",
                                 @"activityId":@"cs40",
                                 @"version":@"5c7edf0cb524838841fcc0f2db1cc642"
                                 };
    
    [self GET:@"http://api.caipiao.163.com/clientHall_hallInfoAll.html" parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"数据%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

@end
