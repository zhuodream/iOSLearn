//
//  AppDelegate.m
//  Quiz
//
//  Created by 7road on 15/7/21.
//  Copyright (c) 2015年 7road. All rights reserved.
//

#import "AppDelegate.h"

#import "QuizViewController.h"
#import <PPAppPlatformKit/PPAppPlatformKit.h>
@interface AppDelegate ()<PPAppPlatformKitDelegate>

@end

@implementation AppDelegate

-(void)ppDylibLoadSucceedCallBack
{
    NSLog(@"chushihuachenggong");
    [[PPAppPlatformKit share] login];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //应用启动后的初始化代码
    QuizViewController *quizVc=[[QuizViewController alloc] init];
    self.window.rootViewController=quizVc;
    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [[PPAppPlatformKit share] setupWithDelegate:self appId:6543 appKey:@"0503ee34898700c9ddd60ac141871efe"];
    [[PPAppPlatformKit share] startPPSDK];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}




@end
