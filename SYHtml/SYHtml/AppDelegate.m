//
//  AppDelegate.m
//  SYHtml
//
//  Created by leju_esf on 16/11/15.
//  Copyright © 2016年 tsy. All rights reserved.
//

#import "AppDelegate.h"
#import "SYVerifyViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSDate *date = [NSDate date];
    [[NSUserDefaults standardUserDefaults] setObject:date forKey:kBecomeBackgroundTime];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:kBecomeBackgroundTime];
    NSInteger second = [date timeIntervalSince1970];
    NSDate *nowDate = [NSDate date];
    NSInteger nowSecond = [nowDate timeIntervalSince1970];
    if (nowSecond - second > 300) {
        SYVerifyViewController *verifyVc = [[SYVerifyViewController alloc] initWithNibName:NSStringFromClass([SYVerifyViewController class]) bundle:nil];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:verifyVc animated:YES completion:nil];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

NSString *const kBecomeBackgroundTime = @"kBecomeBackgroundTime";
