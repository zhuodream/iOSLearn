//
//  ZYXObserverManager.m
//  ZYXObserManager
//
//  Created by 7road on 15/12/22.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "ZYXObserverManager.h"

@interface ZYXObserverManager ()

@property (nonatomic, strong, readonly) NSMutableSet *observers;
@property (nonatomic, strong, readonly) Protocol *protocol;

@end

@implementation ZYXObserverManager

- (id)initWithProtocol:(Protocol *)protocol observers:(NSSet *)observers
{
    if ((self = [super init]))
    {
        _protocol = protocol;
        _observers = [NSMutableSet setWithSet:observers];
    }
    
    return self;
}

- (void)addObserver:(id)observer
{
    NSAssert([observer conformsToProtocol:self.protocol], @"Observer must conform to prorocol.");
    
    [self.observers addObject:observer];
}

- (void)removeObserver:(id)observer
{
    [self.observers removeObject:observer];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSLog(@"接收到函数消息");
    NSMethodSignature *result = [super methodSignatureForSelector:aSelector];
    if (result)
    {
        return result;
    }
    
    struct objc_method_description desc = protocol_getMethodDescription(self.protocol, aSelector, YES, YES);
    if (desc.name == NULL)
    {
        desc = protocol_getMethodDescription(self.protocol, aSelector, NO, YES);
    }
    
    if (desc.name == NULL)
    {
        [self doesNotRecognizeSelector:aSelector];
        return nil;
    }
    
    return [NSMethodSignature signatureWithObjCTypes:desc.types];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    NSLog(@"触发函数消息");
    SEL selector = [anInvocation selector];
    for (id responder in self.observers)
    {
        if ([responder respondsToSelector:selector])
        {
            [anInvocation setTarget:responder];
            [anInvocation invoke];
        }
    }
}

@end
