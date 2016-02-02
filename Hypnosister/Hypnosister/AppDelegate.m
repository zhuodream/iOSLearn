//
//  AppDelegate.m
//  Hypnosister
//
//  Created by 7road on 15/7/21.
//  Copyright (c) 2015年 7road. All rights reserved.
//

#import "AppDelegate.h"
#import "HypnosisView.h"
#import "ZYXSQLiteTools.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
//   // CGRect firstFrame=CGRectMake(160, 240, 100, 150);
//    CGRect firstFrame=self.window.bounds;
//    HypnosisView *firstView=[[HypnosisView alloc] initWithFrame:firstFrame];
//    //firstView.backgroundColor=[UIColor blueColor];
//    [self.window addSubview:firstView];
//    

    //创建两个CGRect结构分别作为UIScrollView对象和Hypnosister对象的frame
    CGRect screenRect=self.window.bounds;
    CGRect bigRect=screenRect;
    bigRect.size.width*=2.0;
    //bigRect.size.height*=2.0;
    
    UIScrollView *scrollView=[[UIScrollView alloc] initWithFrame:screenRect];
    [scrollView setPagingEnabled:YES];
    [self.window addSubview:scrollView];
    
    HypnosisView *hypnosisView=[[HypnosisView alloc] initWithFrame:screenRect];
    [scrollView addSubview:hypnosisView];
    
    //创建第二个大小与屏幕相同的hypnsisView对象并放置在第一个hypnosisiView的右侧，使其刚好移出屏幕外
    screenRect.origin.x+=screenRect.size.width;
    HypnosisView *anotherView=[[HypnosisView alloc]initWithFrame:screenRect];
    [scrollView addSubview:anotherView];
    
    scrollView.contentSize=bigRect.size;
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [[ZYXSQLiteTools getInstance] setPropertyWithName:@"userid" stringValue:@"zhuoyouxin"];
    NSString *name = [[ZYXSQLiteTools getInstance] queryStringPropertyByName:@"userid"];
    NSLog(@"name = %@",name);
    
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
