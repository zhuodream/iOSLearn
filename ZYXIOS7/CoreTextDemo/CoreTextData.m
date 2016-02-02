//
//  CoreTextData.m
//  CoreTextDemo
//
//  Created by 7road on 15/12/29.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "CoreTextData.h"
#import "CoreTextImageData.h"

@implementation CoreTextData

- (void)setCtFrame:(CTFrameRef)ctFrame
{
    if (_ctFrame != ctFrame)
    {
        if (_ctFrame != nil)
        {
            CFRelease(_ctFrame);
        }
        
        CFRetain(ctFrame);
        _ctFrame = ctFrame;
    }
}

- (void)dealloc
{
    if (_ctFrame != nil)
    {
        CFRelease(_ctFrame);
        _ctFrame = nil;
    }
}

- (void)setImageArray:(NSArray *)imageArray
{
    _imageArray = imageArray;
    [self fillImagePosition];
}

- (void)fillImagePosition
{
    if (self.imageArray.count == 0)
    {
        return;
    }
    
    //获取所有的行数信息
    NSArray *lines = (NSArray *)CTFrameGetLines(self.ctFrame);
    
    int lineCount = (int)[lines count];
    CGPoint lineOrigins[lineCount];
    //获取每一行的原点,存储在数组中
    CTFrameGetLineOrigins(self.ctFrame, CFRangeMake(0, 0), lineOrigins);
    
    int imgIndex = 0;
    CoreTextImageData *imageData = self.imageArray[0];
    for (int i = 0; i < lineCount; ++i)
    {
        if (imageData == nil)
        {
            break;
        }
        //获取该行的对象
        CTLineRef line = (__bridge CTLineRef)lines[i];
        //获取每行中的CTRun对象
        NSArray *runObjArray = (NSArray *)CTLineGetGlyphRuns(line);
        for (id runObj in runObjArray)
        {
            CTRunRef run = (__bridge CTRunRef)runObj;
            NSDictionary *runAttributes = (NSDictionary *)CTRunGetAttributes(run);
            CTRunDelegateRef delegate = (__bridge CTRunDelegateRef)[runAttributes valueForKey:(id)kCTRunDelegateAttributeName];
            if (delegate == nil)
            {
                continue;
            }
            
            NSDictionary *metaDic = CTRunDelegateGetRefCon(delegate);
            if (![metaDic isKindOfClass:[NSDictionary class]])
            {
                continue;
            }
            
            CGRect runBounds;
            CGFloat ascent;
            CGFloat desent;
            //获得排版区域的宽度
            runBounds.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &desent, NULL);
            runBounds.size.height = ascent + desent;
            
            //获取在特定位置上的字符的偏移
            CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
            runBounds.origin.x = lineOrigins[i].x + xOffset;
            runBounds.origin.y = lineOrigins[i].y;
            runBounds.origin.y -= desent;
            
            CGPathRef pathRef = CTFrameGetPath(self.ctFrame);
            CGRect colRect = CGPathGetBoundingBox(pathRef);
            NSLog(@"colRect = %@", NSStringFromCGRect(colRect));
            
            CGRect delegateBounds = CGRectOffset(runBounds, colRect.origin.x, colRect.origin.y);
             NSLog(@"deleRect = %@", NSStringFromCGRect(delegateBounds));
            
            imageData.imagePosition = delegateBounds;
            imgIndex++;
            if (imgIndex == self.imageArray.count)
            {
                imageData = nil;
                break;
            }
            else
            {
                imageData = self.imageArray[imgIndex];
            }
        }
    }
}

@end
