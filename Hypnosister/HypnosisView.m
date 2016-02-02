//
//  HypnosisView.m
//  Hypnosister
//
//  Created by 7road on 15/7/21.
//  Copyright (c) 2015年 7road. All rights reserved.
//

#import "HypnosisView.h"
//类扩展实现，当类的某一个属性或方法不需要向其它类公开，则使用类扩展
@interface HypnosisView ()
@property (strong,nonatomic) UIColor *circleColor;

@end


@implementation HypnosisView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if(self)
    {
        //设置背景颜色透明
        self.backgroundColor=[UIColor clearColor];
        self.circleColor=[UIColor lightGrayColor];
    }
    return self;
}

 //Only override drawRect: if you perform custom drawing.
 //An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGRect bounds=self.bounds;
    
    //根据bounds计算中心点
    CGPoint center;
    center.x=bounds.origin.x+bounds.size.width/2.0;
    center.y=bounds.origin.y+bounds.size.height/2.0;
    
    //根据宽和高中的较小值计算圆形的半径
    //float radius=(MIN(bounds.size.width,bounds.size.height)/2.0);
    UIBezierPath *path=[[UIBezierPath alloc] init];
    //[path addArcWithCenter:center radius:radius startAngle:0 endAngle:M_PI*2.0 clockwise:YES];

    //绘制同心圆
    //最外层圆形称为视图的外接圆
    float maxRadius=hypotf(bounds.size.width, bounds.size.height)/2.0;
    for(float currentRadius=maxRadius;currentRadius>0;currentRadius-=20)
    {
        [path moveToPoint:CGPointMake(center.x+currentRadius, center.y)];
        [path addArcWithCenter:center radius:currentRadius startAngle:0 endAngle:M_PI*2.0 clockwise:YES];
    }
    
    
    //设置线条宽度
    path.lineWidth=10;
    
    //设置绘制颜色为浅灰色
    [self.circleColor setStroke];
    

    //绘制路径
    [path stroke];
//    //获取图形上下文
//    CGContextRef currentContext=UIGraphicsGetCurrentContext();
//    //保存上下文
//    CGContextSaveGState(currentContext);
//    //绘制阴影效果
//    CGContextSetShadow(currentContext, CGSizeMake(4, 7), 3);
//    //绘制图片
//    UIImage *logoImage=[UIImage imageNamed:@"logo.png"];
//    [logoImage drawInRect:rect];
//    
//    //恢复没有阴影效果
//    CGContextRestoreGState(currentContext);
//    
//    UIBezierPath *mypath=[[UIBezierPath alloc]init];
//    
//    CGContextSaveGState(currentContext);
//    [mypath moveToPoint:CGPointMake(160, 142)];
//    [mypath addLineToPoint:CGPointMake(260, 446)];
//    [mypath addLineToPoint:CGPointMake(60, 446)];
//    [mypath addLineToPoint:CGPointMake(160, 142)];
//    [mypath stroke];
//    [mypath addClip];
//    //填充渐变
//    CGFloat locations[2]={0.0,1.0};
//    CGFloat components[8]={1.0,1.0,0.0,1.0,
//        0.0,1.0,0.0,1.0};
//    CGColorSpaceRef colorspace=CGColorSpaceCreateDeviceRGB();
//    CGGradientRef gradient=CGGradientCreateWithColorComponents(colorspace, components, locations, 2);
//    CGPoint startPoint=CGPointMake(160, 446);
//    CGPoint endPoint=CGPointMake(160,142);
//    CGContextDrawLinearGradient(currentContext, gradient, startPoint, endPoint, 0);
//    CGGradientRelease(gradient);
//    CGColorSpaceRelease(colorspace);
//    CGContextRestoreGState(currentContext);
}

//HypnosisView被触摸时会收到该消息
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%@ was touched",self);
    
    float red=(arc4random()%100)/100.0;
    float green=(arc4random()%100)/100.0;
    float blue=(arc4random()%100)/100.0;
    
    UIColor *randomColor=[UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    
    self.circleColor=randomColor;
}

-(void)setCircleColor:(UIColor *)circleColor
{
    _circleColor=circleColor;
    [self setNeedsDisplay];
}


@end
