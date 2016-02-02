//
//  ZYXMainThreadTrampoline.m
//  ZYXObserManager
//
//  Created by 7road on 15/12/22.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "ZYXMainThreadTrampoline.h"

@implementation ZYXMainThreadTrampoline

- (id)initWithTarget:(id)aTarget
{
    if ((self = [super init]))
    {
        _target = aTarget;
    }
    
    return self;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    return [self.target methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    [anInvocation setTarget:self.target];
    [anInvocation retainArguments];
    [anInvocation performSelectorOnMainThread:@selector(invoke) withObject:nil waitUntilDone:NO];
}

@end
