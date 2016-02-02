//
//  CTFrameParserConfig.m
//  CoreTextDemo
//
//  Created by 7road on 15/12/29.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "CTFrameParserConfig.h"

@implementation CTFrameParserConfig

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _width = 200.0f;
        _fontSize = 16.0f;
        _lineSpace = 8.0f;
        _textColor = RGB(108, 108, 108);
    }
    
    return self;
}

@end
