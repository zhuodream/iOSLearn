//
//  AppDelegate.h
//  ZYXNSURLSessionDownload
//
//  Created by 7road on 15/11/17.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (copy) void (^backgroundURLSessionCompletionHandler)();

@end

