//
//  CoreTextUtils.m
//  CoreTextDemo
//
//  Created by 7road on 16/1/4.
//  Copyright © 2016年 zhuo. All rights reserved.
//

#import "CoreTextUtils.h"
#import "CoreTextLinkData.h"
#import "CoreTextData.h"

@implementation CoreTextUtils

+ (CoreTextLinkData *)touchLinkInView:(UIView *)view atPoint:(CGPoint)point data:(CoreTextData *)data
{
    CTFrameRef textFrame = data.ctFrame;
    CFArrayRef lines = CTFrameGetLines(textFrame);
    if (!lines)
    {
        return nil;
    }
    
    CFIndex count = CFArrayGetCount(lines);
    CoreTextLinkData *foundLink = nil;
    CGPoint origins[count];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), origins);
    
    //翻转坐标系
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, view.bounds.size.height);
    transform = CGAffineTransformScale(transform, 1.0, -1.0);
    
    for (int i = 0; i < count; ++i)
    {
        CGPoint linePoint = origins[i];
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CGRect flippedRect = [self getLineBounds:line point:linePoint];
        NSLog(@"翻转前的坐标系 = %@", NSStringFromCGRect(flippedRect));
        CGRect rect = CGRectApplyAffineTransform(flippedRect, transform);
        NSLog(@"翻转后的坐标系 = %@", NSStringFromCGRect(rect));
        if (CGRectContainsPoint(rect, point))
        {
            CGPoint relativePoint = CGPointMake(point.x - CGRectGetMinX(rect), point.y - CGRectGetMinY(rect));
            CFIndex idx = CTLineGetStringIndexForPosition(line, relativePoint);
            foundLink = [self lineAtIndex:idx linkArray:data.linkArray];
            return foundLink;
        }
    }
    
    return nil;
}

+ (CGRect)getLineBounds:(CTLineRef)line point:(CGPoint)point
{
    CGFloat ascent = 0.0f;
    CGFloat descent = 0.0f;
    CGFloat leading = 0.0f;
    CGFloat width = (CGFloat)CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    CGFloat height = ascent + descent;
    return CGRectMake(point.x, point.y - descent, width, height);
}

+ (CoreTextLinkData *)lineAtIndex:(CFIndex)i linkArray:(NSArray *)linkArray
{
    CoreTextLinkData *link = nil;
    for (CoreTextLinkData *data in linkArray)
    {
        if (NSLocationInRange(i, data.range))
        {
            link = data;
            break;
        }
    }
    
    return link;
}

@end
