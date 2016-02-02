//
//  DraggableView.m
//  ZYXTearOff
//
//  Created by 7road on 15/12/4.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "DraggableView.h"

@interface DraggableView ()

@property (nonatomic, strong) UISnapBehavior *snapBehavior;
@property (nonatomic, strong) UIDynamicAnimator *dynamicAnimatior;
@property (nonatomic, strong) UIGestureRecognizer *gestureRecognizer;

@end

@implementation DraggableView

- (instancetype)initWithFrame:(CGRect)frame animator:(UIDynamicAnimator *)animator
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _dynamicAnimatior = animator;
        
        self.backgroundColor = [UIColor darkGrayColor];
        self.layer.borderWidth = 2;
        self.gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:self.gestureRecognizer];
    }
    
    return self;
}

- (void)handlePan:(UIPanGestureRecognizer *)g
{
    if (g.state == UIGestureRecognizerStateEnded || g.state == UIGestureRecognizerStateCancelled)
    {
        [self stopDragging];
    }
    else
    {
        [self dragToPoint:[g locationInView:self.superview]];
    }
}

- (void)stopDragging
{
    [self.dynamicAnimatior removeBehavior:self.snapBehavior];
    self.snapBehavior = nil;
}

- (void)dragToPoint:(CGPoint)point
{
    [self.dynamicAnimatior removeBehavior:self.snapBehavior];
    self.snapBehavior = [[UISnapBehavior alloc] initWithItem:self snapToPoint:point];
    
    self.snapBehavior.damping = 0.25;
    [self.dynamicAnimatior addBehavior:self.snapBehavior];
}

- (instancetype)copyWithZone:(NSZone *)zone
{
    DraggableView *newView = [[[self class] alloc] initWithFrame:CGRectZero animator:self.dynamicAnimatior];
    
    newView.bounds = self.bounds;
    newView.center = self.center;
    newView.transform = self.transform;
    newView.alpha = self.alpha;
    
    return newView;
}


@end
