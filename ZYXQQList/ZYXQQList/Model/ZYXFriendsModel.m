//
//  ZYXFriendsModel.m
//  ZYXQQList
//
//  Created by 7road on 15/10/15.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "ZYXFriendsModel.h"

@implementation ZYXFriendsModel


- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        [self setValuesForKeysWithDictionary:dict];
    }
    
    return  self;
}

+ (instancetype)friendWithDict:(NSDictionary *)dict
{
    return  [[self alloc] initWithDict:dict];
}
@end