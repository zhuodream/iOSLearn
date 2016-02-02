//
//  CTFrameParser.h
//  CoreTextDemo
//
//  Created by 7road on 15/12/29.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CTFrameParserConfig;
@class CoreTextData;

@interface CTFrameParser : NSObject

+ (CoreTextData *)parseContent:(NSString *)content config:(CTFrameParserConfig *)config;

+ (NSMutableDictionary *)attributiesWithConfig:(CTFrameParserConfig *)config;

+ (CoreTextData *)parseAttributedContent:(NSAttributedString *)attributedString config:(CTFrameParserConfig *)config;

/**
 *  解析模板文件，并生成CoreTextData对象
 *
 *  @param path   文件路径
 *  @param config 文字排版配置信息
 *
 *  @return CoreTextData对象
 */
+ (CoreTextData *)parseTemplateFile:(NSString *)path config:(CTFrameParserConfig *)config;

@end
