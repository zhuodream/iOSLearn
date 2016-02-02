//
//  CoreTextUtils.h
//  CoreTextDemo
//
//  Created by 7road on 16/1/4.
//  Copyright © 2016年 zhuo. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CoreTextLinkData;
@class CoreTextData;

@interface CoreTextUtils : NSObject

+ (CoreTextLinkData *)touchLinkInView:(UIView *)view atPoint:(CGPoint)point data:(CoreTextData *)data;

@end
