//
//  ZYXLayoutManager.m
//  ZYXCustomText
//
//  Created by 7road on 15/12/10.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "ZYXLayoutManager.h"
#import "ZYXScribbleTextStorage.h"

@implementation ZYXLayoutManager

- (void)drawGlyphsForGlyphRange:(NSRange)glyphsToShow atPoint:(CGPoint)origin
{
    NSLog(@"glyphsToShow = %@", NSStringFromRange(glyphsToShow));
    //确定字符范围以便检查属性
    NSRange characterRange = [self characterRangeForGlyphRange:glyphsToShow actualGlyphRange:NULL];
    //每次ZYXRedactStyleAttributeName变化都遍历一遍
    [self.textStorage enumerateAttribute:ZYXRedactStyleAttributeName
                                 inRange:characterRange
                                 options:0
                              usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
                                  NSLog(@"range = %@", NSStringFromRange(range));
                                  NSLog(@"value = %@", value);
        [self redactCharacterRange:range ifTrue:value atPoint:origin];
    }];
}

- (void)redactCharacterRange:(NSRange)characterRange ifTrue:(NSNumber *)value atPoint:(CGPoint)origin
{
    //切换回字形范围
    NSRange glyphRange = [self glyphRangeForCharacterRange:characterRange actualCharacterRange:NULL];
    
    if ([value boolValue])
    {
        //准备好context,原点按视图坐标系计算
        //下面的方法会返回文本容器的坐标
        //应用变换
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        //需要先翻转
        CGContextTranslateCTM(context, origin.x, origin.y);
        
        [[UIColor blackColor] setStroke];
        
        NSLog(@"glyphRange = %@", NSStringFromRange(glyphRange));
        //遍历包围绝密文本字形的连续矩形
        NSTextContainer *containter = [self textContainerForGlyphAtIndex:glyphRange.location effectiveRange:NULL];
        [self enumerateEnclosingRectsForGlyphRange:glyphRange withinSelectedGlyphRange:NSMakeRange(NSNotFound, 0) inTextContainer:containter usingBlock:^(CGRect rect, BOOL * _Nonnull stop) {
            [self drawRedactionInRect:rect];
        }];
        CGContextRestoreGState(context);
    }
    else
    {
        //非绝密文本，采用默认行为
        [super drawGlyphsForGlyphRange:glyphRange atPoint:origin];
    }
}

- (void)drawRedactionInRect:(CGRect)rect
{
    //绘制一个带叉的方框
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
    CGFloat minX = CGRectGetMinX(rect);
    CGFloat minY = CGRectGetMinY(rect);
    CGFloat maxX = CGRectGetMaxX(rect);
    CGFloat maxY = CGRectGetMaxY(rect);
    [path moveToPoint:CGPointMake(minX, minY)];
    [path addLineToPoint:CGPointMake(maxX, maxY)];
    [path moveToPoint:CGPointMake(maxX, minY)];
    [path addLineToPoint:CGPointMake(minX, maxY)];
    [path stroke];
}

- (void)drawBackgroundForGlyphRange:(NSRange)glyphsToShow atPoint:(CGPoint)origin
{
    [super drawBackgroundForGlyphRange:glyphsToShow atPoint:origin];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    NSRange characterRange = [self characterRangeForGlyphRange:glyphsToShow actualGlyphRange:NULL];
    
    [self.textStorage enumerateAttribute:ZYXHighlightColorAttributeName inRange:characterRange options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        [self hightlightCharacterRange:range color:value atPoint:origin inContext:context];
    }];
    
}

- (void)hightlightCharacterRange:(NSRange)hightlightCharacterRange
                           color:(UIColor *)color
                         atPoint:(CGPoint)origin
                       inContext:(CGContextRef)context
{
    if (color)
    {
        CGContextSaveGState(context);
        [color setFill];
        CGContextTranslateCTM(context, origin.x, origin.y);
        
        NSRange highlightedGlyphRange = [self glyphRangeForCharacterRange:hightlightCharacterRange actualCharacterRange:NULL];
        NSTextContainer *contatiner = [self textContainerForGlyphAtIndex:highlightedGlyphRange.location effectiveRange:NULL];
        
        [self enumerateEnclosingRectsForGlyphRange:highlightedGlyphRange withinSelectedGlyphRange:NSMakeRange(NSNotFound, 0) inTextContainer:contatiner usingBlock:^(CGRect rect, BOOL * _Nonnull stop) {
            [self drawHightlightInRect:rect];
        }];
        CGContextRestoreGState(context);
    }
}


- (void)drawHightlightInRect:(CGRect)rect
{
    CGRect highlightRect = CGRectInset(rect, -3, -3);
    UIRectFill(highlightRect);
    [[UIBezierPath bezierPathWithOvalInRect:highlightRect] stroke];
}

@end
