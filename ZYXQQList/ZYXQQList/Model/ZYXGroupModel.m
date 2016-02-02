//
//  ZYXGroupModel.m
//  ZYXQQList
//
//  Created by 7road on 15/10/15.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "ZYXGroupModel.h"
#import "ZYXFriendsModel.h"

@implementation ZYXGroupModel


- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        [self setValuesForKeysWithDictionary:dict];
        NSMutableArray *muArray = [NSMutableArray array];
        for (NSDictionary *dict in self.friends)
        {
            ZYXFriendsModel *model = [ZYXFriendsModel friendWithDict:dict];
            [muArray addObject:model];
        }
        self.friends = muArray;
    }
    
    return self;
}
+ (instancetype)GroupWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

@end
