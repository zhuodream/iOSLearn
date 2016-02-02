//
//  CoreTextLabel.m
//  ZYXSimpleLayout
//
//  Created by 7road on 15/12/12.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "CoreTextLabel.h"
@import CoreText;

@implementation CoreTextLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        CGAffineTransform transform = CGAffineTransformMakeScale(1, -1);
        //反转坐标空间，core text是左下角为原点
        CGAffineTransformTranslate(transform, 0, -self.bounds.size.height);
        self.transform = transform;
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)setAttributeString:(NSMutableAttributedString *)attributeString
{
    if (attributeString != _attributeString)
    {
        _attributeString = [attributeString copy];
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    //绘制文本之前需要设置文本变换，或者说改变文本矩阵
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    
    //创建填充路径，在本例中是整个视图
    CGPathRef path = CGPathCreateWithRect(self.bounds, NULL);
    
    CFAttributedStringRef attrString = (__bridge CFTypeRef)self.attributeString;
    
    //用属性化字符串创建框架排版器
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(attrString);
    
    //用整个字符串（CFRange(0, 0)）创建一个可以装进填充路径的框架
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    
    //在当前上下文中绘制
    CTFrameDraw(frame, context);
    
    CFRelease(frame);
    CFRelease(framesetter);
    CFRelease(path);
}

@end
