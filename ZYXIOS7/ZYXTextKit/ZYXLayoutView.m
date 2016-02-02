//
//  LayoutView.m
//  ZYXTextKit
//
//  Created by 7road on 15/12/8.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "ZYXLayoutView.h"

@interface ZYXLayoutView () <NSLayoutManagerDelegate>

@property (nonatomic, strong) NSLayoutManager *layoutManager;
@property (nonatomic, strong) NSTextContainer *textContainer;

@end

@implementation ZYXLayoutView

- (void)awakeFromNib
{
    CGSize size = self.bounds.size;
    size.width /= 2;
    NSLog(@"size.width = %f", size.width);
    self.textContainer = [[NSTextContainer alloc] initWithSize:size];
    self.layoutManager = [NSLayoutManager new];
    self.layoutManager.delegate = self;
    [self.layoutManager addTextContainer:self.textContainer];
    
    [self.textView.textStorage addLayoutManager:self.layoutManager];
}

- (void)layoutManagerDidInvalidateLayout:(NSLayoutManager *)sender
{
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    NSLog(@"aaaaaaa");
    NSLayoutManager *lm = self.layoutManager;
    NSRange range = [lm glyphRangeForTextContainer:self.textContainer];
    CGPoint point = CGPointZero;
    [lm drawBackgroundForGlyphRange:range atPoint:point];
    [lm drawGlyphsForGlyphRange:range atPoint:point];
}


@end
