//
//  TearOffBehavior.h
//  ZYXTearOff
//
//  Created by 7road on 15/12/4.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DraggableView;

typedef void(^TearOffHandler) (DraggableView *tornView, DraggableView *newPinView);

@interface TearOffBehavior : UIDynamicBehavior

@property (nonatomic, assign) BOOL active;

- (instancetype)initWithDraggableView:(DraggableView *)view anchor:(CGPoint)anchor handler:(TearOffHandler)handler;

@end
