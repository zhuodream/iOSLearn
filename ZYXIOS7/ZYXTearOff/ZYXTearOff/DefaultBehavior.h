//
//  DefaultBehavior.h
//  ZYXTearOff
//
//  Created by 7road on 15/12/4.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DefaultBehavior : UIDynamicBehavior

- (void)addItem:(id<UIDynamicItem>)item;

- (void)removeItem:(id<UIDynamicItem>)item;

@end
