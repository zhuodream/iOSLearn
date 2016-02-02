//
//  AppDelegate.h
//  ZYiHotel
//
//  Created by 7road on 15/11/23.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESTfulEngine.h"
#import "iHotelNavigationController.h"

#define iHotelAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

@class iHotelAppViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) RESTfulEngine *engine;

@property (nonatomic, strong) NSString *loh;

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet iHotelNavigationController *navigationController;



@end

