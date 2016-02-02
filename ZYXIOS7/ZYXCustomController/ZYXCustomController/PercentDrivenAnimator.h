//
//  PercentDrivenAnimator.h
//  ZYXCustomController
//
//  Created by 7road on 15/12/7.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PercentDrivenAnimator : UIPercentDrivenInteractiveTransition

- (instancetype)initWithViewController:(UIViewController *)controller;
- (void)pinchGesturnAction:(UIPinchGestureRecognizer *)gestureRecognizer;

@end
