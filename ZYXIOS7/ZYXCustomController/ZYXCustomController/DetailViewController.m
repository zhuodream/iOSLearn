//
//  DetailViewController.m
//  ZYXCustomController
//
//  Created by 7road on 15/12/7.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "DetailViewController.h"
#import "PercentDrivenAnimator.h"

@interface DetailViewController ()
- (void)configureView;

@property (nonatomic, strong) PercentDrivenAnimator *animator;

@end

@implementation DetailViewController

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem)
    {
        _detailItem = newDetailItem;
        
        [self configureView];
    }
}

- (IBAction)closeButtonTapped:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
    self.animator = [[PercentDrivenAnimator alloc] initWithViewController:self];
    UIPinchGestureRecognizer *gr = [[UIPinchGestureRecognizer alloc] initWithTarget:self.animator action:@selector(pinchGesturnAction:)];
    
    [self.view addGestureRecognizer:gr];
    NSLog(@"self.transitionDeleagte = %@", self.transitioningDelegate);
//    if (self.transitioningDelegate != nil)
//    {
//        self.transitioningDelegate = nil;
//    }
//    self.transitioningDelegate = self;
}

//UIViewControllerAnimatedTransition
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 1.0f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *src = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        CGPoint centerPoint = src.view.center;
        [UIView animateWithDuration:1.0 animations:^{
            src.view.frame = CGRectMake(centerPoint.x, centerPoint.y, 10, 10);
            src.view.center = centerPoint;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];

}

//- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext
//{
//    UIViewController *src = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
//    CGPoint centerPoint = src.view.center;
//    [UIView animateWithDuration:1.0 animations:^{
//        src.view.frame = CGRectMake(centerPoint.x, centerPoint.y, 10, 10);
//        src.view.center = centerPoint;
//    } completion:^(BOOL finished) {
//        [transitionContext completeTransition:YES];
//    }];
//}

- (void)configureView
{
    if (self.detailItem)
    {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return self.animator;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return self.animator;
}


@end
