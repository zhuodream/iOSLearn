//
//  BNRDetailViewController.h
//  Homepwner
//
//  Created by 7road on 15/7/24.
//  Copyright (c) 2015年 7road. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BNRItem;

@interface BNRDetailViewController : UIViewController <UIViewControllerRestoration>

@property (nonatomic,strong) BNRItem *item;
-(instancetype)initForNewItem:(BOOL)isNew;
//保存block对象
@property (nonatomic,copy) void (^dismissBlock)(void);


@end
