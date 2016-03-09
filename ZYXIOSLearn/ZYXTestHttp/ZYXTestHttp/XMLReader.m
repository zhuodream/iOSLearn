//
//  XMLReader.m
//  ZYXTestHttp
//
//  Created by 7road on 16/3/8.
//  Copyright © 2016年 zhuo. All rights reserved.
//

#import "XMLReader.h"

NSString *const kXMLReaderTextNodeKey = @"text";

@interface XMLReader ()

@property (nonatomic, strong) NSMutableArray *dictionaryStack;
@property (nonatomic, strong) NSMutableString *textInProgress;
@property (nonatomic, assign) NSError *__autoreleasing *error;

@end

@implementation XMLReader

+ (NSDictionary *)dictionaryForXMLData:(NSData *)data error:(NSError *__autoreleasing *)error
{
    XMLReader *reader = [[XMLReader alloc] initWithError:error];
    NSDictionary *rootDictionary = [reader objectWithData:data];
    
    return rootDictionary;
}

+ (NSDictionary *)dictionaryForXMLString:(NSString *)string error:(NSError *__autoreleasing *)error
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [XMLReader dictionaryForXMLData:data error:error];
}

- (instancetype)initWithError:(NSError **)error
{
    if (self = [super init])
    {
        self.error = error;
    }
    
    return self;
}

- (NSDictionary *)objectWithData:(NSData *)data
{
    self.dictionaryStack = [[NSMutableArray alloc] init];
    self.textInProgress = [[NSMutableString alloc] init];
    
    [self.dictionaryStack addObject:[NSMutableDictionary dictionary]];
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    
    BOOL success = [parser parse];
    
    if (success)
    {
        NSDictionary *resultDic = [self.dictionaryStack objectAtIndex:0];
        NSLog(@"resultarray ========== %ld", self.dictionaryStack.count);
        return resultDic;
    }
    
    return nil;
}

#pragma mark - NSXMLDeleagte methods
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict
{
    NSLog(@"elementName = %@", elementName);
    NSLog(@"namespaceURI = %@", namespaceURI);
    NSLog(@"qualifiedName = %@", qName);
    NSLog(@"attributeDict = %@", attributeDict);
    NSMutableDictionary *parentDict = [self.dictionaryStack lastObject];
    
    NSMutableDictionary *childDict = [NSMutableDictionary dictionary];
    [childDict addEntriesFromDictionary:attributeDict];
    
    id existingValue = [parentDict objectForKey:elementName];
    if (existingValue)
    {
        NSMutableArray *array = nil;
        if ([existingValue isKindOfClass:[NSMutableArray class]])
        {
            array = (NSMutableArray *)existingValue;
        }
        else
        {
            array = [NSMutableArray array];
            [array addObject:existingValue];
            
            [parentDict setObject:array forKey:elementName];
        }
        
        [array addObject:childDict];
    }
    else
    {
        [parentDict setObject:childDict forKey:elementName];
    }
    
    [self.dictionaryStack addObject:childDict];
    NSLog(@"1111111111111111111111111111");
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    NSLog(@"2222222222222222222222222222");
    NSMutableDictionary *dictInProgress = [self.dictionaryStack lastObject];
    if ([self.textInProgress length] > 0)
    {
        [dictInProgress setObject:self.textInProgress forKey:kXMLReaderTextNodeKey];
        
        self.textInProgress = [[NSMutableString alloc] init];
    }
    
    [self.dictionaryStack removeLastObject];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    NSLog(@"string ====== %@", string);
    [self.textInProgress appendString:string];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    *self.error = parseError;
}

@end
