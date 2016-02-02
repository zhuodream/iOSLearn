//
//  ViewController.m
//  ZYXAnimation3D
//
//  Created by 7road on 15/11/12.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

const CGFloat kSize = 100.;
const CGFloat kPanScale = 1./100.;

- (CALayer *)layerWihthColor:(UIColor *)color
                   transform:(CATransform3D)transform
{
    CALayer *layer = [CALayer layer];
    layer.backgroundColor = [color CGColor];
    layer.bounds = CGRectMake(0, 0, kSize, kSize);
    layer.position = self.view.center;
    layer.transform = transform;
    [self.view.layer addSublayer:layer];
    
    return layer;
}

static CATransform3D MakePerspectiveTransform()
{
    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = -1./2000.;
    
    return perspective;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    CATransform3D transform;
    transform = CATransform3DMakeTranslation(0, -kSize/2, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 1.0, 0, 0);
    self.topLayer = [self layerWihthColor:[UIColor redColor] transform:transform];
    
    transform = CATransform3DMakeTranslation(0, kSize/2, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 1.0, 0, 0);
    self.bottomLayer = [self layerWihthColor:[UIColor greenColor] transform:transform];
    
    transform = CATransform3DMakeTranslation(kSize/2, 0, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 0, 1, 0);
    self.rightLayer = [self layerWihthColor:[UIColor blueColor] transform:transform];

    transform = CATransform3DMakeTranslation(-kSize/2, 0, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 0, 1, 0);
    self.leftLayer = [self layerWihthColor:[UIColor cyanColor] transform:transform];
    
    transform = CATransform3DMakeTranslation(0, 0, -kSize/2);
    transform = CATransform3DRotate(transform, M_PI_2, 0, 0, 0);
    self.backLayer = [self layerWihthColor:[UIColor yellowColor] transform:transform];
    
    transform = CATransform3DMakeTranslation(0, 0, kSize/2);
    transform = CATransform3DRotate(transform, M_PI_2, 0, 0, 0);
    self.frontLayer = [self layerWihthColor:[UIColor magentaColor] transform:transform];

    self.view.layer.sublayerTransform = MakePerspectiveTransform();
    
    UIGestureRecognizer *g = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    
    [self.view addGestureRecognizer:g];
}

- (void)pan:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self.view];
    CATransform3D transform = MakePerspectiveTransform();
    transform = CATransform3DRotate(transform, kPanScale * translation.x, 0, 1, 0);
    transform = CATransform3DRotate(transform, kPanScale * translation.y, 1, 0, 0);
    
    self.view.layer.sublayerTransform = transform;
}


@end
