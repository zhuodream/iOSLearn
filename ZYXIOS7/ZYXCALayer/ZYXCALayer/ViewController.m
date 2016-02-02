//
//  ViewController.m
//  ZYXCALayer
//
//  Created by 7road on 15/11/9.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "ViewController.h"
#import "DelegateView.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *image = [UIImage imageNamed:@"pushing"];
    self.view.layer.contentsScale = [[UIScreen mainScreen] scale];
    self.view.layer.contentsGravity = kCAGravityCenter;
    self.view.layer.contents = (id)[image CGImage];
    
    UIGestureRecognizer *g = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(performFlip:)];
    
    [self.view addGestureRecognizer:g];
}

- (void)performFlip:(UIGestureRecognizer *)recognizer
{
    UIView *delegateView = [[DelegateView alloc] initWithFrame:self.view.frame];
    [UIView transitionFromView:self.view toView:delegateView duration:1 options:UIViewAnimationOptionTransitionFlipFromRight completion:nil];
}

@end
