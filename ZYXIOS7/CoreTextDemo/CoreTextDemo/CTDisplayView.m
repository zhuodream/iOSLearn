//
//  CTDisplayView.m
//  CoreTextDemo
//
//  Created by 7road on 15/12/29.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "CTDisplayView.h"
#import "CoreTextData.h"
#import "CoreTextImageData.h"
#import "CoreTextLinkData.h"
#import "CoreTextUtils.h"

@implementation CTDisplayView

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
//    //获取绘图的上下文
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    //设置文本变换，也可以说是改变文本矩阵,并且改变绘图坐标，原点在上
//    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
//    CGContextTranslateCTM(context, 0, self.bounds.size.height);
//    CGContextScaleCTM(context, 1.0, -1.0);
//    
//    //绘制路径
//    CGMutablePathRef path = CGPathCreateMutable();
//    //CGPathAddRect(path, NULL, self.bounds);
//    CGPathAddEllipseInRect(path, NULL, self.bounds);
//    //生成绘制框架对象CTFrame
//    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:@"Hello World!"
//        "创建绘制的区域， CoreText本身支持各种文字排版的区域，"
//        "我们这里简单的将UIView的整个界面作为排版的区域。"
//        "为了加深理解，建议读者将步骤替换为如下代码，"
//        "测试设置不同的绘制区域带来的界面变化"];
//    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString);
//    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attString.length), path, NULL);
//    
//    //绘制
//    CTFrameDraw(frame, context);
//    
//    //释放对象
//    CFRelease(frame);
//    CFRelease(path);
//    CFRelease(framesetter);

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    if (self.data)
    {
        CTFrameDraw(self.data.ctFrame, context);
    }
    
    for (CoreTextImageData *imageData in self.data.imageArray)
    {
        UIImage *image = [UIImage imageNamed:imageData.name];
        NSLog(@"image = %@", image);
        if (image)
        {
            CGContextDrawImage(context, imageData.imagePosition, image.CGImage);
            NSLog(@"imagePosition = %@", NSStringFromCGRect(imageData.imagePosition));
        }
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setupEvents];
    }
    
    return self;
}

- (void)setupEvents
{
    UIGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTapGestureDetected:)];
    //tapRecognizer.delegate = self;
    [self addGestureRecognizer:tapRecognizer];
    self.userInteractionEnabled = YES;
}

- (void)userTapGestureDetected:(UIGestureRecognizer *)recognizer
{
    CGPoint point = [recognizer locationInView:self];
    for (CoreTextImageData *imageData in self.data.imageArray)
    {
        //翻转坐标系，因为imageData中的坐标是CoreText的坐标系
        CGRect imageRect = imageData.imagePosition;
        CGPoint imagePosition = imageRect.origin;
        imagePosition.y = self.bounds.size.height - imageRect.origin.y - imageRect.size.height;
        CGRect rect = CGRectMake(imagePosition.x, imagePosition.y, imageRect.size.width, imageRect.size.height);
        //检测点击位置是否在rect内
        if (CGRectContainsPoint(rect, point))
        {
            //在这里处理点击后的逻辑
            NSLog(@"bingo");
            break;
        }
    }
    
    CoreTextLinkData *linkData = [CoreTextUtils touchLinkInView:self atPoint:point data:self.data];
    if (linkData)
    {
        NSLog(@"hit link!");
        return;
    }
}

@end
