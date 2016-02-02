//
//  BNRColorDescription.m
//  Colorboard
//
//  Created by 7road on 15/9/9.
//  Copyright (c) 2015年 7road. All rights reserved.
//

#import "BNRColorDescription.h"

@implementation BNRColorDescription


- (instancetype) init
{
    self=[super init];
    if(self)
    {
        _color=[UIColor colorWithRed:0 green:0 blue:1 alpha:1];
        
        _name=@"Blue";
    }
    
    return self;
}
@end
