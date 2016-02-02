//
//  Son.m
//  ZYXDynamicClass
//
//  Created by 7road on 15/11/11.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "Son.h"

@implementation Son

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        NSLog(@"%@", NSStringFromClass([self class]));
        NSLog(@"%@", NSStringFromClass([super class]));
    }
    
    return self;
}

@end
