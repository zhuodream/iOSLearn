//
//  AppDelegate.m
//  HypneNerd
//
//  Created by 7road on 15/7/23.
//  Copyright (c) 2015年 7road. All rights reserved.
//

#import "AppDelegate.h"
#import "HypnosisViewController.h"
#import "ReminderViewController.h"
#import "QuizViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
//    [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];//注册本地推送
    
    HypnosisViewController *hvc=[[HypnosisViewController alloc]init];
    //获取指向NSBundle对象的指针，该NSBundle对象代表应用的主程序包
    NSBundle *appBundle=[NSBundle mainBundle];
    
    //告诉初始化方法在appBundle中查找ReminderViewController.xib文件
    ReminderViewController *rvc=[[ReminderViewController alloc]initWithNibName:@"ReminderViewController" bundle:appBundle];
    
    QuizViewController *qvc=[[QuizViewController alloc] initWithNibName:@"QuizViewController" bundle:appBundle];
    
    
    //创建UITabBarController对象，可以保存一组视图控制器，并在屏幕底部显示标签
    UITabBarController *tabBarController=[[UITabBarController alloc] init];
    tabBarController.viewControllers=@[hvc,rvc,qvc];
    
    
    self.window.rootViewController=tabBarController;
    
    
    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
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
