//
//  ZYXScribbleTextStorage.m
//  ZYXCustomText
//
//  Created by 7road on 15/12/9.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "ZYXScribbleTextStorage.h"

NSString * const ZYXDefaultTokenName = @"ZYXDefaultTokenName";

NSString * const ZYXRedactStyleAttributeName = @"ZYXRedactStyleAttributeName";
NSString * const ZYXHighlightColorAttributeName = @"ZYXHighlightColorAttributeName";

@interface ZYXScribbleTextStorage ()

@property (nonatomic, strong) NSMutableAttributedString *backingStore;
@property (nonatomic, assign) BOOL dynamicTextNeedsUpdate;

@end

@implementation ZYXScribbleTextStorage

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _backingStore = [NSMutableAttributedString new];
    }
    
    return self;
}

//获取保存的字符串
- (NSString *)string
{
    return [self.backingStore string];
}

//获取指定范围的文字属性
- (NSDictionary *)attributesAtIndex:(NSUInteger)location effectiveRange:(nullable NSRangePointer)range
{
    return [self.backingStore attributesAtIndex:location effectiveRange:range];
}

//修改指定范围内的文字属性
- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str
{
    //必须调用beginEditing和endEditing
    [self beginEditing];
    [self.backingStore replaceCharactersInRange:range withString:str];
    //通知和记录新的设置
    [self edited:NSTextStorageEditedCharacters|NSTextStorageEditedAttributes range:range changeInLength:str.length - range.length];
    self.dynamicTextNeedsUpdate = YES;
    [self endEditing]; //endEditing之后会发送processEditing
}

//设置指定范围内的文字属性
- (void)setAttributes:(NSDictionary<NSString *,id> *)attrs range:(NSRange)range
{
    [self beginEditing];
    [self.backingStore setAttributes:attrs range:range];
    //通知和记录新的设置
    [self edited:NSTextStorageEditedAttributes range:range changeInLength:0];
    [self endEditing];
}

- (void)processEditing
{
    if (self.dynamicTextNeedsUpdate)
    {
        self.dynamicTextNeedsUpdate = NO;
        [self performReplacementsForCharacterChangeInRange:[self editedRange]];
    }
    
    [super processEditing];
}

- (void)performReplacementsForCharacterChangeInRange:(NSRange)changedRange
{
    NSString *string = [self.backingStore string];
    
    NSRange startLine = NSMakeRange(changedRange.location, 0);
    NSRange endLine = NSMakeRange(NSMaxRange(changedRange), 0);
    
    NSRange extendedRange = NSUnionRange(changedRange, [string lineRangeForRange:startLine]);
    extendedRange = NSUnionRange(extendedRange, [string lineRangeForRange:endLine]);
    
    [self applyTokenAttributesToRange:extendedRange];
}


- (void)applyTokenAttributesToRange:(NSRange)searchRange
{
    NSDictionary *defaultAttributes = self.tokens[ZYXDefaultTokenName];
    
    NSString *string = [self.backingStore string];
    [string enumerateSubstringsInRange:searchRange options:NSStringEnumerationByWords usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {

        NSDictionary *attributesForToken = self.tokens[substring];
        if (!attributesForToken)
        {
            attributesForToken = defaultAttributes;
        }
        if (attributesForToken)
        {
            [self setAttributes:attributesForToken range:substringRange];
        }
    }];
}

@end
