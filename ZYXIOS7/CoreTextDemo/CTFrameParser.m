//
//  CTFrameParser.m
//  CoreTextDemo
//
//  Created by 7road on 15/12/29.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "CTFrameParser.h"
#import "CTFrameParserConfig.h"
#import "CoreTextData.h"
#import "CoreTextImageData.h"
#import "CoreTextLinkData.h"

@implementation CTFrameParser

static CGFloat ascentCallback(void *ref)
{
    return [(NSNumber *)[(__bridge NSDictionary *)ref objectForKey:@"height"] floatValue];
}

static CGFloat descentCallback(void *ref)
{
    return 0;
}

static CGFloat widthCallback(void *ref)
{
    return [(NSNumber *)[(__bridge NSDictionary *)ref objectForKey:@"width"] floatValue];
}

+ (NSMutableDictionary *)attributiesWithConfig:(CTFrameParserConfig *)config
{
    CGFloat fontSize = config.fontSize;
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", fontSize, NULL);
    CGFloat lineSpace = config.lineSpace;
    const CFIndex kNumberOfSettings = 3;
    CTParagraphStyleSetting theSettings[kNumberOfSettings] = {
        { kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof(CGFloat), &lineSpace},
        { kCTParagraphStyleSpecifierMaximumLineSpacing, sizeof(CGFloat), &lineSpace},
        { kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(CGFloat), &lineSpace}
    };
    
    CTParagraphStyleRef theParagraphRef = CTParagraphStyleCreate(theSettings, kNumberOfSettings);
    
    UIColor *textColor = config.textColor;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[(id)kCTForegroundColorAttributeName] = (id)textColor.CGColor;
    dict[(id)kCTFontAttributeName] = (__bridge id)fontRef;
    dict[(id)kCTParagraphStyleAttributeName] = (__bridge id)theParagraphRef;
    
    CFRelease(theParagraphRef);
    CFRelease(fontRef);
    return dict;
}

+ (CoreTextData *)parseContent:(NSString *)content config:(CTFrameParserConfig *)config
{
    NSDictionary *attributes = [self attributiesWithConfig:config];
    
    NSAttributedString *contentString = [[NSAttributedString alloc] initWithString:content attributes:attributes];
    NSLog(@"string === %@", contentString.string);
    //创建CTFramesetterRef实例
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)contentString);
    
    //获得要绘制的区域的高度
    CGSize restrictSize = CGSizeMake(config.width, CGFLOAT_MAX);
    CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, restrictSize, nil);
    CGFloat textHeight = coreTextSize.height;
    
    //生成CTFrameRef实例
    CTFrameRef frame = [self createFrameWithFramesetter:framesetter config:config height:textHeight];
    
    //将生成号的CTFrameRef实例和计算好的绘制高度保存到CoreTextData实例中，最后返回CoreTextData实例
    CoreTextData *data = [[CoreTextData alloc] init];
    data.ctFrame = frame;
    data.height = textHeight;
    
    //释放内存
    CFRelease(frame);
    CFRelease(framesetter);
    
    return data;
}

+ (CoreTextData *)parseAttributedContent:(NSAttributedString *)attributedString config:(CTFrameParserConfig *)config
{
    NSLog(@"attributedString = %@", attributedString);
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
    
    //获得要绘制的区域的高度
    CGSize restrictSize = CGSizeMake(config.width, CGFLOAT_MAX);
    CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), NULL, restrictSize, NULL);
    CGFloat textheight = coreTextSize.height;
    
    //生成CTFrameRef实例
    CTFrameRef frame = [self createFrameWithFramesetter:framesetter config:config height:textheight];
    
    //将生成好的CTFrameRef实例和计算好的绘制高度保存到CoreTextData实例中
    CoreTextData *data = [[CoreTextData alloc] init];
    data.ctFrame = frame;
    data.height = textheight;
    
    CFRelease(framesetter);
    CFRelease(frame);
    
    return data;
}


+ (CTFrameRef)createFrameWithFramesetter:(CTFramesetterRef)framesetter config:(CTFrameParserConfig *)config height:(CGFloat)height
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, config.width, height));
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CFRelease(path);
    return frame;
}

+ (CoreTextData *)parseTemplateFile:(NSString *)path config:(CTFrameParserConfig *)config
{
    NSMutableArray *imageArray = [NSMutableArray array];
    NSMutableArray *linkArray = [NSMutableArray array];
    NSAttributedString *content = [self loadTemplateFile:path config:config imageArray:imageArray linkArray:linkArray];
    CoreTextData *data = [self parseAttributedContent:content config:config];
    data.imageArray = imageArray;
    data.linkArray = linkArray;
    return data;
}

+ (NSAttributedString *)loadTemplateFile:(NSString *)path config:(CTFrameParserConfig *)config imageArray:(NSMutableArray *)imageArray linkArray:(NSMutableArray *)linkArray
{
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
    
    if (data)
    {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        if ([array isKindOfClass:[NSArray class]])
        {
            for (NSDictionary *dict in array)
            {
                NSString *type = dict[@"type"];
                if ([type isEqualToString:@"txt"])
                {
                    NSAttributedString *as = [self parseAttributedContentFromNSDictionary:dict config:config];
                    
                    [result appendAttributedString:as];
                }
                else if ([type isEqualToString:@"img"])
                {
                    //创建CoreTextImageData
                    CoreTextImageData *imageData = [[CoreTextImageData alloc] init];
                    imageData.name = dict[@"name"];
                    imageData.position = (int)[result length];
                    [imageArray addObject:imageData];
                    //创建空白占位符，并且设置它的CTRundelegate信息
                    NSAttributedString *as = [self parseImageDataFromeDictionary:dict config:config];
                    [result appendAttributedString:as];
                }
                else if ([type isEqualToString:@"link"])
                {
                    NSUInteger startPos = result.length;
                    NSAttributedString *as = [self parseAttributedContentFromNSDictionary:dict config:config];
                    [result appendAttributedString:as];
                    //创建CoreTextLinkData
                    NSUInteger length = result.length - startPos;
                    NSRange linkRange = NSMakeRange(startPos, length);
                    CoreTextLinkData *linkData = [[CoreTextLinkData alloc] init];
                    linkData.title = dict[@"content"];
                    linkData.url = dict[@"url"];
                    linkData.range = linkRange;
                    [linkArray addObject:linkData];
                }
            }
        }
    }
    
    return result;
}

+ (NSAttributedString *)parseAttributedContentFromNSDictionary:(NSDictionary *)dict config:(CTFrameParserConfig *)config
{
    NSMutableDictionary *attributes = [self attributiesWithConfig:config];
    
    //设置颜色
    UIColor *color = [self colorFromTemplate:dict[@"color"]];
    if (color)
    {
        attributes[(id)kCTForegroundColorAttributeName] = (id)color.CGColor;
    }
    
    //设置字体大小
    CGFloat fontSize = [dict[@"size"] floatValue];
    if (fontSize > 0)
    {
        CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", fontSize, NULL);
        attributes[(id)kCTFontAttributeName] = (__bridge id)fontRef;
        CFRelease(fontRef);
    }
    
    NSString *content = dict[@"content"];
    return [[NSAttributedString alloc] initWithString:content attributes:attributes];
}

+ (NSAttributedString *)parseImageDataFromeDictionary:(NSDictionary *)dict config:(CTFrameParserConfig *)config
{
    CTRunDelegateCallbacks callbacks;
    memset(&callbacks, 0, sizeof(CTRunDelegateCallbacks));
    callbacks.version = kCTRunDelegateVersion1;
    callbacks.getAscent = ascentCallback;
    callbacks.getDescent = descentCallback;
    callbacks.getWidth = widthCallback;
    CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, (__bridge void *)dict);
   
    //使用0xFFFC作为空白的占位符
    unichar objectReplacementChar = 0xFFFC;
    NSString *content = [NSString stringWithCharacters:&objectReplacementChar length:1];
    NSDictionary *attributes = [self attributiesWithConfig:config];
    NSMutableAttributedString *space = [[NSMutableAttributedString alloc] initWithString:content attributes:attributes];
    
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)space, CFRangeMake(0, 1), kCTRunDelegateAttributeName, delegate);
    CFRelease(delegate);
    
    return space;
}



+ (UIColor *)colorFromTemplate:(NSString *)name
{
    if ([name isEqualToString:@"blue"])
    {
        return [UIColor blueColor];
    }
    else if ([name isEqualToString:@"red"])
    {
        return [UIColor redColor];
    }
    else if ([name isEqualToString:@"black"])
    {
        return [UIColor blackColor];
    }
    else
    {
        return nil;
    }
}



@end
