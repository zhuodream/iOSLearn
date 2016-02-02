//
//  RESTfulEngine.h
//  ZYiHotel
//
//  Created by 7road on 15/11/23.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "MKNetworkHost.h"
@class JSONModel;
@class RESTfulOperation;

#define kAccessTokenDefaultsKey @"ACCESS_TOKEN"

typedef void (^VoidBlock) (void);
typedef void (^ModelBlock) (JSONModel *aModelBaseObject);
typedef void (^ArrayBlock) (NSMutableArray *listofModelBaseObjects);
typedef void (^ErrorBlock) (NSError *engineError);

@interface RESTfulEngine : MKNetworkHost
{
    NSString *_accessToken;
}

@property (nonatomic) NSString *accessToken;


- (id)loginWithName:(NSString *)loginName password:(NSString *)password onSucceeded:(VoidBlock)succeededBlock onError:(ErrorBlock) errorBlock;


- (RESTfulOperation *)fetchMenuItemsSucceeded:(ArrayBlock)succeededBlock onError:(ErrorBlock)errorBlock;

- (RESTfulOperation *)fetchMenuItemsFromWrongLocationOnSucceeded:(ArrayBlock)succeededBlock onError:(ErrorBlock)errorBlock;

@end
