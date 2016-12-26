//
//  SYHtmlManager.m
//  SYHtml
//
//  Created by leju_esf on 16/11/15.
//  Copyright © 2016年 tsy. All rights reserved.
//

#import "SYHtmlManager.h"
#import "SYArticleModel.h"
#import "SVProgressHUD.h"

#define SYBaseUrl @"https://www.aa924.com"

#define SYCacheKey @"SYHtmlManagerKey"

@interface SYHtmlManager ()<NSURLSessionTaskDelegate>
@property (nonatomic, strong) NSURLSession *session;

@end

@implementation SYHtmlManager
SYSingleton_implementation(SYHtmlManager)

- (void)requestDataWithUrl:(NSString *)urlString andType:(SYHtmlType)type completion:(void(^)(id response))completion {
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:SYCacheKey];
    if ([dict.allKeys containsObject:urlString]) {
        NSData *locationData = [dict objectForKey:urlString];
        [self handleData:locationData WithType:type completion:completion];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SYBaseUrl,urlString]];
        NSURLSessionTask *task = [self.session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (data) {
                NSString *html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSString *locationHtml = [[NSString alloc] initWithData:locationData encoding:NSUTF8StringEncoding];
                if (![html isEqualToString:locationHtml]) {
                     [self handleData:data WithType:type completion:completion];
                }
                NSDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:SYCacheKey];
                NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:dict];
                [tempDict setObject:data forKey:urlString];
                [[NSUserDefaults standardUserDefaults] setObject:tempDict forKey:SYCacheKey];
            }
        }];
        [task resume];
    }else {
        [SVProgressHUD show];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SYBaseUrl,urlString]];
        NSURLSessionTask *task = [self.session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            [SVProgressHUD dismiss];
            if (data) {
                [self handelData:data];
                NSDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:SYCacheKey];
                NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:dict];
                [tempDict setObject:data forKey:urlString];
                [[NSUserDefaults standardUserDefaults] setObject:tempDict forKey:SYCacheKey];
                [self handleData:data WithType:type completion:completion];
            }
        }];
         [task resume];
    }
}

- (void)handleData:(NSData *)data WithType:(SYHtmlType)type completion:(void(^)(id response))completion {
    if (type == SYHtmlTypeArticleList) {
        [self articleListData:data completion:completion];
    }else if(type == SYHtmlTypeArticle) {
        [self articleData:data completion:completion];
    }else if (type == SYHtmlTypePictureList) {
        [self pictureListData:data completion:completion];
    }else if (type == SYHtmlTypePicture) {
        [self pictureData:data completion:completion];
    }
}

/*
 在此代理方法里面挑战服务器
 如果发送的是https,这个代理方法会自动去接收服务器发送给客户端的受保护空间
 challenge : 存放受保护空间的
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * __nullable credential))completionHandler
{
    // 1.判断信任服务器的方式是否是依据安全证书
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        
        // 2.从受保护空间里面拿到受信任的证书
        NSURLCredential *cre = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        
        // 3.把证书回调给服务器,告诉服务器,我信任你
        completionHandler(NSURLSessionAuthChallengeUseCredential,cre);
    }
}

- (void)handelData:(NSData *)data {
    NSString *html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",html);
}

- (void)articleListData:(NSData *)data completion:(void(^)(id response))completion{
    [self listData:data completion:completion];
}

- (void)pictureListData:(NSData *)data completion:(void(^)(id response))completion{
    [self listData:data completion:completion];
}

- (void)listData:(NSData *)data completion:(void(^)(id response))completion{
    
    NSString *html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",html);
    NSRange contentStartRange = [html rangeOfString:@"<script type=\"text/javascript\">document.writeln(listad);</script>"];
    if (contentStartRange.length == 0) {
        return;
    }
    NSString *sub = [html substringFromIndex:contentStartRange.location];
    NSString *listContent = [self contentBetweenStart:@"<script type=\"text/javascript\">document.writeln(listad);</script>" andEnd:@"</ul>" inString:sub];
    NSArray *list = [listContent componentsSeparatedByString:@"<li>"];
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 1; i < list.count; i++) {
        NSString *content = list[i];
        NSString *url = [self contentBetweenStart:@"<a href=\"" andEnd:@"\" target" inString:content];
        NSString *title = [self contentBetweenStart:@"</span>" andEnd:@"</a></li>" inString:content];
        SYArticleModel *model = [[SYArticleModel alloc] init];
        model.url = url;
        model.title = title;
        [tempArray addObject:model];
    }
    //    [tempArray sy_saveModelsByArchive];
    if (completion) {
        completion(tempArray);
    }
}

- (void)pictureData:(NSData *)data completion:(void(^)(id response))completion {

    NSString *html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",html);
    NSString *content = [self contentBetweenStart:@"<div id=\"picTopAds\"></div>" andEnd:@"<div id=\"picFootAds\"></div>" inString:html];
    NSArray *list = [content componentsSeparatedByString:@"<br>"];
    NSLog(@"%@",list);
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0; i < list.count - 1; i++) {
        NSString *content = list[i];
        NSString *url = [self contentBetweenStart:@"src=\"" andEnd:@"\">" inString:content];
        [tempArray addObject:url];
    }
    completion(tempArray);
}

- (void)articleData:(NSData *)data completion:(void(^)(id response))completion{

    NSString *html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSRange titleRange = [html rangeOfString:@"<div class=\"page_title\">"];
    NSString *sub = [html substringFromIndex:titleRange.location];
    NSString *title = [self contentBetweenStart:@"<div class=\"page_title\">" andEnd:@"</div>" inString:sub];

    NSString *text = [self contentBetweenStart:@"<div id=\"picTopAds\">" andEnd:@"<div id=\"picFootAds\">" inString:html];
    
    SYArticleModel *model = [[SYArticleModel alloc] init];
    model.title = title;
    model.text = text;
    if (completion) {
        completion(model);
    }
}

- (NSString *)contentBetweenStart:(NSString *)start andEnd:(NSString *)end inString:(NSString *)string{
    NSRange startRange = [string rangeOfString:start];
    NSRange endRnage = [string rangeOfString:end];
    if (startRange.length > 0 && endRnage.length > 0) {
        NSString *text = [string substringWithRange:NSMakeRange(startRange.location+startRange.length, endRnage.location - startRange.location - startRange.length)];
        return text;
    }else {
        return nil;
    }
}

- (NSURLSession *)session{
    if (_session == nil) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}

@end
