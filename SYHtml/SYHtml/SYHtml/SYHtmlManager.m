//
//  SYHtmlManager.m
//  SYHtml
//
//  Created by leju_esf on 16/11/15.
//  Copyright © 2016年 tsy. All rights reserved.
//

#import "SYHtmlManager.h"

@implementation SYHtmlManager
SYSingleton_implementation(SYHtmlManager)

- (void)requestData {
    NSURL *url = [NSURL URLWithString:@"https://www.aa924.com/htm/vodlist1"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
   NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
       NSLog(@"%@----%@",response,data);
   }];
    [task resume];
}
@end
