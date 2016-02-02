//
//  AppDelegate.m
//  Homepwner
//
//  Created by 7road on 15/7/23.
//  Copyright (c) 2015年 7road. All rights reserved.
//

#import "AppDelegate.h"
#import "BNRItemViewController.h"
#import "BNRItemStore.h"

NSString * const BNRNextItemValuePrefsKey=@"NextItemValue";
NSString * const BNRNextItemNamePrefsKey=@"NextItemName";


@interface AppDelegate ()

@end

@implementation AppDelegate

+ (void)initialize
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *factorySettings=@{BNRNextItemValuePrefsKey:@75,BNRNextItemNamePrefsKey:@"coffe Cup"};
    [defaults registerDefaults:factorySettings];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
     NSLog(@"%@",NSStringFromSelector(_cmd));
   
    //如果应用没有出发状态恢复，则创建并设置各个视图控制器
    if(!self.window.rootViewController)
    {
        BNRItemViewController *itemViewController=[[BNRItemViewController alloc] init];
        //创建UINavigationController对象，该对象的栈只包含itemsViewController
        UINavigationController *navController=[[UINavigationController alloc] initWithRootViewController:itemViewController];
        
        //为UINavigationController对象设置恢复标识
        navController.restorationIdentifier=NSStringFromClass([navController class]);
        
        //将UINavigationController的表视图加入窗口层次结构
        self.window.rootViewController=navController;
    }
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    NSLog(@"%@",NSStringFromSelector(_cmd));
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    BOOL success=[[BNRItemStore sharedStore]saveChanges];
    if(success)
    {
        NSLog(@"Saved all of the BNRItems");
    }
    else
    {
        NSLog(@"Could not save any of the BNRItems");    
    }
     NSLog(@"%@",NSStringFromSelector(_cmd));
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     NSLog(@"%@",NSStringFromSelector(_cmd));
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     NSLog(@"%@",NSStringFromSelector(_cmd));
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
     NSLog(@"%@",NSStringFromSelector(_cmd));
}

//状态保存
- (BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder
{
    return YES;
}

- (BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder
{
    return YES;
}

//系统恢复应用状态之前调用的方法
- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window=[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor=[UIColor whiteColor];
    return YES;
}

//如果需要恢复的对象没有恢复类，则需要应用程序委托创建该对象
- (UIViewController *)application:(UIApplication *)application viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    //创建一个新的UINavigationController对象
    UIViewController *vc=[[UINavigationController alloc] init];
    
    //恢复标识路径中的最后一个对象就是UINavigationController对象
    vc.restorationIdentifier=[identifierComponents lastObject];
    
    //如果恢复标识路径中只有一个对象，就将UINavigationController对象设置为UIWindow的rootViewController
    if([identifierComponents count]==1)
    {
        self.window.rootViewController=vc;
    }
    
    return vc;
}

@end
