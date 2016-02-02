//
//  ZYXCurvyTextView.m
//  ZYXCurvyText
//
//  Created by 7road on 15/12/11.
//  Copyright © 2015年 zhuo. All rights reserved.
//


#import "ZYXCurvyTextView.h"

static const CGFloat kControlPointSize = 13;

@interface ZYXCurvyTextView ()

@property (nonatomic, assign) CGPoint P0;//起点
@property (nonatomic, assign) CGPoint P1;//控制点
@property (nonatomic, assign) CGPoint P2;//控制点
@property (nonatomic, assign) CGPoint P3;//终点
@property (nonatomic, strong) NSLayoutManager *layouMananger;
@property (nonatomic, strong) NSTextStorage *textStorage;

@end

@implementation ZYXCurvyTextView

//更新控制点
- (void)updateControlPoints
{
    NSArray *subViews = self.subviews;
    self.P0 = [subViews[0] center];
    self.P1 = [subViews[1] center];
    self.P2 = [subViews[2] center];
    self.P3 = [subViews[3] center];
    
    [self setNeedsDisplay];
}

//添加控制点
- (void)addControlPoint:(CGPoint)point color:(UIColor *)color
{
    //使控制点的实际的view  3x 点的大小，可以轻松点击
    CGRect fullRect = CGRectMake(0, 0, kControlPointSize*3, kControlPointSize*3);
    CGRect rect = CGRectInset(fullRect, kControlPointSize, kControlPointSize);
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    CGPathRef path = CGPathCreateWithEllipseInRect(rect, NULL);
    shapeLayer.path = path;
    shapeLayer.fillColor = color.CGColor;
    CGPathRelease(path);
    
    UIView *view = [[UIView alloc] initWithFrame:fullRect];
    [view.layer addSublayer:shapeLayer];
    
    UIGestureRecognizer *g = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [view addGestureRecognizer:g];
    
    [self addSubview:view];
    view.center = point;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addControlPoint:CGPointMake(50, 500) color:[UIColor greenColor]];
        [self addControlPoint:CGPointMake(300, 300) color:[UIColor blackColor]];
        [self addControlPoint:CGPointMake(400, 700) color:[UIColor blackColor]];
        [self addControlPoint:CGPointMake(650, 500) color:[UIColor redColor]];
        [self updateControlPoints];
        
        _layouMananger = [NSLayoutManager new];
        NSTextContainer *textContainer = [NSTextContainer new];
        _textStorage = [[NSTextStorage alloc] init];
        
        [_layouMananger addTextContainer:textContainer];
        [_textStorage addLayoutManager:_layouMananger];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)pan:(UIPanGestureRecognizer *)g
{
    g.view.center = [g locationInView:self];
    [self updateControlPoints];
}

- (NSAttributedString *)attributedString
{
    return self.textStorage;
}

- (void)setAttributedString:(NSMutableAttributedString *)attributedString
{
    [self.textStorage setAttributedString:attributedString];
}

- (void)drawPath
{
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:self.P0];
    [path addCurveToPoint:self.P3 controlPoint1:self.P1 controlPoint2:self.P2];
    [[UIColor blueColor] setStroke];
    [path stroke];
}


//计算曲线上的点
static double Bezier(double t, double P0, double P1, double P2, double P3)
{
    return (1-t)*(1-t)*(1-t)*P0 + 3*(1-t)*(1-t)*t*P1 + 3*(1-t)*t*t*P2 + t*t*t*P3;
}

//计算曲线的斜率
static double BezierPrime(double t, double P0, double P1,
                          double P2, double P3) {
    return
    -  3 * (1-t)*(1-t) * P0
    + (3 * (1-t)*(1-t) * P1) - (6 * t * (1-t) * P1)
    - (3 *         t*t * P2) + (6 * t * (1-t) * P2)
    +  3 * t*t * P3;
}

//下面两个方法获取曲线上的点和角度
- (CGPoint)pointForOffset:(double)t
{
    double x = Bezier(t, _P0.x, _P1.x, _P2.x, _P3.x);
    double y = Bezier(t, _P0.y, _P1.y, _P2.y, _P3.y);
    return CGPointMake(x, y);
}

- (double)angleForOffset:(double)t {
    double dx = BezierPrime(t, _P0.x, _P1.x, _P2.x, _P3.x);
    double dy = BezierPrime(t, _P0.y, _P1.y, _P2.y, _P3.y);
    return atan2(dy, dx);
}


static double Distance(CGPoint a, CGPoint b)
{
    CGFloat dx = a.x - b.x;
    CGFloat dy = a.y - b.y;
    return hypot(dx, dy);
}

// Simplistic routine to find the offset along Bezier that is
// aDistance away from aPoint. anOffset is the offset used to
// generate aPoint, and saves us the trouble of recalculating it
// This routine just walks forward until it finds a point at least
// aDistance away. Good optimizations here would reduce the number
// of guesses, but this is tricky since if we go too far out, the
// curve might loop back on leading to incorrect results. Tuning
// kStep is good start.
- (double)offsetAtDistance:(double)aDistance fromPoint:(CGPoint)aPoint andOffSet:(double)anOffset
{
    const double kStep = 0.001;
    double newDistance = 0;
    double newOffset = anOffset + kStep;
    while (newDistance <= aDistance && newOffset < 1.0)
    {
        newOffset += kStep;
        newDistance = Distance(aPoint, [self pointForOffset:newOffset]);
    }
    
    return newOffset;
}

- (void)drawText
{
    if ([self.attributedString length] == 0)
    {

        return;
    }
    
    NSLayoutManager *layoutManager = self.layouMananger;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    NSRange glyphRange;
    CGRect lineRect = [layoutManager lineFragmentUsedRectForGlyphAtIndex:0 effectiveRange:&glyphRange];
    
    double offset = 0;
    CGPoint lastGlyphPoint = self.P0;
    CGFloat lastX = 0;
    for (NSUInteger glyphIndex = glyphRange.location; glyphIndex < NSMaxRange(glyphRange); ++glyphIndex)
    {
        CGContextSaveGState(context);
        
        CGPoint location = [layoutManager locationForGlyphAtIndex:glyphIndex];
        
        CGFloat distance = location.x - lastX;
        offset = [self offsetAtDistance:distance fromPoint:lastGlyphPoint andOffSet:offset];
        CGPoint glyphPoint = [self pointForOffset:offset];
        double angle = [self angleForOffset:offset];
        
        lastGlyphPoint = glyphPoint;
        lastX = location.x;
        
        CGContextTranslateCTM(context, glyphPoint.x, glyphPoint.y);
        CGContextRotateCTM(context, angle);
        
        [layoutManager drawGlyphsForGlyphRange:NSMakeRange(glyphIndex, 1) atPoint:CGPointMake(-(lineRect.origin.x + location.x),-(lineRect.origin.y + location.y))];
        
        CGContextRestoreGState(context);
    }
}

- (void)drawRect:(CGRect)rect
{
    [self drawPath];
    [self drawText];
}


@end
