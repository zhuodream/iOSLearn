//
//  TearOffBehavior.m
//  ZYXTearOff
//
//  Created by 7road on 15/12/4.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "TearOffBehavior.h"
#import "DraggableView.h"

@implementation TearOffBehavior

- (instancetype)initWithDraggableView:(DraggableView *)view anchor:(CGPoint)anchor handler:(TearOffHandler)handler
{
    self = [super init];
    if (self)
    {
        _active = YES;
        //如果要移动到新点，必须删除该行为再添加，并且如果两个迅速行为控制相同的视图，该视图最终位置会在两个移动点之间
        [self addChildBehavior:[[UISnapBehavior alloc] initWithItem:view snapToPoint:anchor]];
    
        CGFloat distance = MIN(CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds));
        TearOffBehavior * __weak weakself = self;
        self.action = ^{
            TearOffBehavior *strongself = weakself;
            if (!PointsAreWithinDistance(view.center, anchor, distance))
            {
                if (strongself.active)
                {
                    //DraggableView需要实现NSCopying协议，并实现copyWithZone的方法
                    DraggableView *newView = [view copy];
                    [view.superview addSubview:newView];
        
                    TearOffBehavior *newTearOff = [[[strongself class] alloc] initWithDraggableView:newView anchor:anchor handler:handler];
                    
                    newTearOff.active = NO;
                    [strongself.dynamicAnimator addBehavior:newTearOff];
                    handler(view, newView);
                    [strongself.dynamicAnimator removeBehavior:strongself];
                }
            }
            else
            {
                strongself.active = YES;
            }
        };
    }
    
    return self;
}

BOOL PointsAreWithinDistance(CGPoint p1, CGPoint p2, CGFloat distance)
{
   
    CGFloat dx = p1.x - p2.x;
    CGFloat dy = p1.y - p2.y;
    CGFloat currentDistance = hypotf(dx, dy);
    
    return (currentDistance < distance);
}

@end
