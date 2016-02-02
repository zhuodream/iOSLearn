//
//  AppDelegate.m
//  ZYXSearch
//
//  Created by 7road on 15/10/16.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "AppDelegate.h"
#import "Products.h"
#import "MainTableViewController.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // load our data source and hand it over to APLMainTableViewController
    //
    NSArray *products = @[[Products productWithType:[Products deviceTypeTitle]
                                                 name:@"iPhone"
                                                 year:@2007
                                                price:@599.00],
                          [Products productWithType:[Products deviceTypeTitle]
                                                 name:@"iPod"
                                                 year:@2001
                                                price:@399.00],
                          [Products productWithType:[Products deviceTypeTitle]
                                                 name:@"iPod touch"
                                                 year:@2007
                                                price:@210.00],
                          [Products productWithType:[Products deviceTypeTitle]
                                                 name:@"iPad"
                                                 year:@2010
                                                price:@499.00],
                          [Products productWithType:[Products deviceTypeTitle]
                                                 name:@"iPad mini"
                                                 year:@2012
                                                price:@659.00],
                          [Products productWithType:[Products deviceTypeTitle]
                                                 name:@"iMac"
                                                 year:@1997
                                                price:@1299.00],
                          [Products productWithType:[Products deviceTypeTitle]
                                                 name:@"Mac Pro"
                                                 year:@2006
                                                price:@2499.00],
                          [Products productWithType:[Products portableTypeTitle]
                                                 name:@"MacBook Air"
                                                 year:@2008
                                                price:@1799.00],
                          [Products productWithType:[Products portableTypeTitle]
                                                 name:@"MacBook Pro"
                                                 year:@2006
                                                price:@1499.00]
                          ];
    
    UINavigationController *navigationController = (UINavigationController *)(self.window).rootViewController;
    // note we want the first view controller (not the visibleViewController) in case
    // we are being store from UIStateRestoration
    //
    ViewController *viewController = (ViewController *)navigationController.viewControllers[0];
    viewController.products = products;

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
