//
//  ZYXCircleAnimateView.m
//  SQ-PhonePlug
//
//  Created by 7road on 16/1/21.
//  Copyright © 2016年 zhuo. All rights reserved.
//

#import "ZYXCircleAnimateView.h"

#define CLScreenWidth [UIScreen mainScreen].bounds.size.width
#define CLScreenHeight [UIScreen mainScreen].bounds.size.height
#define CLScreenBounds [UIScreen mainScreen].bounds

@interface ZYXCircleAnimateView ()

@property (nonatomic, strong) CAShapeLayer *progressLayer;

@end

@implementation ZYXCircleAnimateView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        _progressLineWidth = 3;
        
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.fillColor = [UIColor redColor].CGColor;
        _progressLayer.lineWidth = 5;
        _progressLayer.strokeColor = [UIColor colorWithRed:82/255.0 green:125/255.0 blue:173/255.0 alpha:1.0].CGColor;
        [self setLayerPath];
        _progressLayer.frame = CGRectMake(self.center.x - 50, self.center.y - 50, 100, 100);
        _progressLayer.backgroundColor = [UIColor blackColor].CGColor;
        [self.layer addSublayer:_progressLayer];
        
    }
    
    return self;
}



- (void)setLayerPath
{
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(50, 50) radius:50 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
   
    _progressLayer.path = path.CGPath;
}


- (void)startAnimation
{
    _progressLayer.strokeStart = 0.0f;
    _progressLayer.strokeEnd = 0.8f;
    [self createAnimation];
}

- (void)createAnimation
{
    
    CABasicAnimation *anim;
    anim=[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    anim.duration = 1;
    anim.repeatCount= MAXFLOAT;
    anim.toValue=[NSNumber numberWithFloat:2 * M_PI];
    [_progressLayer addAnimation:anim forKey:@"circleRotation"];
}

- (void)stopAnimation
{
    [_progressLayer removeAnimationForKey:@"circleRotation"];
    [self removeFromSuperview];
}

@end
