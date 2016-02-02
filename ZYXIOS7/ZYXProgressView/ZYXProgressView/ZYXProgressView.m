//
//  ZYXProgressView.m
//  SQ-PhonePlug
//
//  Created by 7road on 16/1/21.
//  Copyright © 2016年 zhuo. All rights reserved.
//

#import "ZYXProgressView.h"

@interface ZYXProgressView ()

@property (nonatomic, strong) CAShapeLayer *backgroundLayer;
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ZYXProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        self.alpha = 1.0f;
        self.backgroundLineWidth = 3;
        self.progressLineWidth = 3;
        _percentage = 0.6;
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.frame = self.bounds;
        _progressLayer.fillColor = nil;
        _progressLayer.strokeColor = [UIColor blueColor].CGColor;
        _progressLayer.lineWidth = 20;
        
        _backgroundLayer = [CAShapeLayer layer];
        _backgroundLayer.frame = self.bounds;
        _backgroundLayer.fillColor = nil;
        _backgroundLayer.strokeColor = [UIColor brownColor].CGColor;
        _backgroundLayer.lineWidth = 20;
        [self setBackgroundLayerPath];
        self.progressLabel.text = @"0%";
        self.progressLabel.textAlignment = NSTextAlignmentCenter;
        self.progressLabel.font = [UIFont systemFontOfSize:25 weight:0.4];
        [self setBackgroundProgressLinePath];
        [self addSubview:self.progressLabel];
        [self.layer addSublayer:_backgroundLayer];
        [self.layer addSublayer:_progressLayer];
        
    }
    
    return self;
}

- (void)setBackgroundProgressLinePath
{
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.center radius:50 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    _progressLayer.path = path.CGPath;
}

- (void)setBackgroundLayerPath
{
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.center radius:50 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    _backgroundLayer.path = path.CGPath;
}


- (UILabel *)progressLabel
{
    if (!_progressLabel)
    {
        _progressLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.bounds.size.width - 100)/2, (self.bounds.size.height - 100)/2, 100, 100)];
    }
    return _progressLabel;
}

- (void)show
{
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//    animation.fromValue = [NSNumber numberWithFloat:0.0];
//    animation.toValue = [NSNumber numberWithFloat:1.0f];
//    //_progressLayer.strokeEnd = _percentage;
//    animation.duration = 5.0f;
//    [_progressLayer addAnimation:animation forKey:@"strokeEndAnimation"];
    _progressLayer.strokeEnd = 0;
//    [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
}

- (void)setProgress:(CGFloat)progress
{
    if (_progressLayer.strokeEnd < 1)
    {
        _progressLayer.strokeEnd += progress;
        NSLog(@"结束");
    }
}



@end
