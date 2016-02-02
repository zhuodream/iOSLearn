//
//  ZYXScribbleTextStorage.h
//  ZYXCustomText
//
//  Created by 7road on 15/12/9.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const ZYXDefaultTokenName;
extern NSString * const ZYXRedactStyleAttributeName;
extern NSString * const ZYXHighlightColorAttributeName;

@interface ZYXScribbleTextStorage : NSTextStorage

@property (nonatomic, readwrite, copy) NSDictionary *tokens;

@end
