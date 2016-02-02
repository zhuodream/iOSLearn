//
//  FlowerTransformView.m
//  ZYXFlowersTransformView
//
//  Created by 7road on 15/10/15.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "FlowerTransformView.h"


@implementation FlowerTransformView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGSize size = self.bounds.size;
    CGFloat margin = 10;
    
    [[UIColor redColor] set];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(0, -1)
                    radius:1
                startAngle:(CGFloat)-M_PI
                  endAngle:0
                 clockwise:YES];
    [path addArcWithCenter:CGPointMake(1, 0)
                    radius:1
                startAngle:(CGFloat)-M_PI_2
                  endAngle:(CGFloat)M_PI_2
                 clockwise:YES];
    [path addArcWithCenter:CGPointMake(0, 1)
                    radius:1
                startAngle:0
                  endAngle:(CGFloat)M_PI
                 clockwise:YES];
    [path addArcWithCenter:CGPointMake(-1, 0)
                    radius:1
                startAngle:(CGFloat)M_PI_2
                  endAngle:(CGFloat)-M_PI_2
                 clockwise:YES];
    
    CGFloat scale = floorf((MIN(size.height, size.width) - margin) / 4);
    CGAffineTransform transform = CGAffineTransformMakeScaleTranslate(scale, scale, size.width / 2, size.height / 2);
    [path applyTransform:transform];
    [path fill];
    
}


- (void)awakeFromNib
{
    self.contentMode = UIViewContentModeRedraw;
}

static inline CGAffineTransform CGAffineTransformMakeScaleTranslate(CGFloat sx, CGFloat sy, CGFloat dx, CGFloat dy)
{
    return CGAffineTransformMake(sx, 0.f, 0.f, sy, dx, dy);
}


@end
