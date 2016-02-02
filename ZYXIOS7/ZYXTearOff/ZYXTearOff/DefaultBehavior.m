//
//  DefaultBehavior.m
//  ZYXTearOff
//
//  Created by 7road on 15/12/4.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "DefaultBehavior.h"

@implementation DefaultBehavior

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        UICollisionBehavior *collisionBehavior = [UICollisionBehavior new];
        collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
        [self addChildBehavior:collisionBehavior];
        
        [self addChildBehavior:[UIGravityBehavior new]];
    }
    
    return self;
}

- (void)addItem:(id<UIDynamicItem>)item
{
    for (id behavior in self.childBehaviors)
    {
        [behavior addItem:item];
    }
}

- (void)removeItem:(id<UIDynamicItem>)item
{
    for (id behavior in self.childBehaviors)
    {
        [behavior removeItem:item];
    }
}

@end
