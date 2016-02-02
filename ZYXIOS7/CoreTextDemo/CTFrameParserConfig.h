//
//  CTFrameParserConfig.h
//  CoreTextDemo
//
//  Created by 7road on 15/12/29.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTFrameParserConfig : NSObject

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat fontSize;

@property (nonatomic, assign) CGFloat lineSpace;
@property (nonatomic, strong) UIColor *textColor;

@end
