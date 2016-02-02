//
//  PercentDrivenAnimator.m
//  ZYXCustomController
//
//  Created by 7road on 15/12/7.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "PercentDrivenAnimator.h"

@interface PercentDrivenAnimator ()

@property (nonatomic, assign) float startScale;
@property (weak, nonatomic) UIViewController *controller;

@end

@implementation PercentDrivenAnimator

- (instancetype)initWithViewController:(UIViewController *)controller
{
    if ((self = [super init]))
    {
        self.controller = controller;
    }
    
    return self;
}

- (void)pinchGesturnAction:(UIPinchGestureRecognizer *)gestureRecognizer
{
    CGFloat scale = gestureRecognizer.scale;
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        self.startScale = scale;
        [self.controller dismissViewControllerAnimated:YES completion:nil];
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        CGFloat completePercent = 1.0 - (scale/self.startScale);
        [self updateInteractiveTransition:completePercent];
    }
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        if (gestureRecognizer.velocity >= 0)
        {
            [self cancelInteractiveTransition];
        }
        else
            [self finishInteractiveTransition];
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateCancelled)
    {
        [self cancelInteractiveTransition];
    }
}

@end
