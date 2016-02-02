//
//  LayerAnimationViewController.m
//  LayerAnimation
//
//  Copyright (c) 2012 Rob Napier
//
//  This code is licensed under the MIT License:
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
//  DEALINGS IN THE SOFTWARE.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CALayer *squareLayer = [CALayer layer];
    squareLayer.backgroundColor = [[UIColor redColor] CGColor];
    squareLayer.frame = CGRectMake(100, 100, 20, 20);
    [self.view.layer addSublayer:squareLayer];
    
    UIView *squareView = [UIView new];
    squareView.backgroundColor = [UIColor blueColor];
    squareView.frame = CGRectMake(200, 100, 20, 20);
    [self.view addSubview:squareView];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //此处使用动画需要注意，不要使用autolayout，否则动画效果不会出现
    [self.view addGestureRecognizer:
     [[UITapGestureRecognizer alloc]
      initWithTarget:self
      action:@selector(drop:)]];

}


- (void)drop:(UIGestureRecognizer *)recognizer {
    
    NSLog(@"aaaaaaaa");
    [CATransaction setAnimationDuration:2.0];
    NSArray *layers = self.view.layer.sublayers;
    CALayer *layer = [layers objectAtIndex:0];
    CGPoint toPoint = CGPointMake(200, 250);
    NSArray *views = self.view.subviews;
    UIView *view = [views objectAtIndex:0];
       [UIView animateWithDuration:2.0 animations:^{
    [layer setPosition:toPoint];
    
    //  CABasicAnimation *anim = [CABasicAnimation
    //                            animationWithKeyPath:@"opacity"];
    //  anim.fromValue = @1.0;
    //  anim.toValue = @0.0;
    //  anim.autoreverses = YES;
    //  anim.repeatCount = INFINITY;
    //  anim.duration = 2.0;
    //  [layer addAnimation:anim forKey:@"anim"];
    
   
   [view setCenter:CGPointMake(100, 250)];

      
//        self.view.bounds = CGRectMake(0, 0, 50, 50);
        //[self.view layoutIfNeeded];
    }];
    
    [self performSegueWithIdentifier:@"aaaa" sender:self];
    
}

@end