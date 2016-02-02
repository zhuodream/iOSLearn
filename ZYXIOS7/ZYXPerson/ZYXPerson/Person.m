//
//  Person.m
//  ZYXPerson
//
//  Created by 7road on 15/12/22.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "Person.h"
#import <objc/runtime.h>

@interface Person ()

@property (strong) NSMutableDictionary *properties;

@end

@implementation Person

@dynamic givenName, surname;

- (id)init
{
    if ((self = [super init]))
    {
        _properties = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

static id propertyIMP(id self, SEL _cmd)
{
    return [[self properties] valueForKey:NSStringFromSelector(_cmd)];
}

static void setPropertyIMP(id self, SEL _cmd, id aValue)
{
    id value = [aValue copy];
    
    NSMutableString *key = [NSStringFromSelector(_cmd) mutableCopy];
    
    //删除set和:以及第一个小写字符
    [key deleteCharactersInRange:NSMakeRange(0, 3)];
    [key deleteCharactersInRange:NSMakeRange([key length] - 1, 1)];
    
    NSString *firstChar = [key substringToIndex:1];
    [key replaceCharactersInRange:NSMakeRange(0, 1) withString:[firstChar lowercaseString]];
    
    [[self properties] setValue:value forKey:key];
}

+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    if ([NSStringFromSelector(sel) hasPrefix:@"set"])
    {
        //返回值为void，三个参数，第一个为id @:表示接受一个id和SEL参数，第三个代表参数为id
        class_addMethod([self class], sel, (IMP)setPropertyIMP, "v@:@");
    }
    else
    {
        class_addMethod([self class], sel, (IMP)propertyIMP, "@@:");
    }
    
    return YES;
}

@end
