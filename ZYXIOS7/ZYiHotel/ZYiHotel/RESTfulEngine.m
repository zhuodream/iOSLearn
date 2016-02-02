//
//  RESTfulEngine.m
//  ZYiHotel
//
//  Created by 7road on 15/11/23.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "RESTfulEngine.h"
#import "RESTfulOperation.h"
#import "MenuItem.h"

@implementation RESTfulEngine


- (NSString *)accessToken
{
    if (!_accessToken)
    {
        _accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:kAccessTokenDefaultsKey];
    }
    
    return _accessToken;
}

- (void)setAccessToken:(NSString *)aAccessToken
{
    _accessToken = aAccessToken;
    
    [[NSUserDefaults standardUserDefaults] setObject:self.accessToken forKey:kAccessTokenDefaultsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)prepareRequest:(MKNetworkRequest *)networkRequest
{
    NSLog(@"prepareRequest");
    if (self.accessToken)
    {
        [networkRequest setAuthorizationHeaderValue:self.accessToken forAuthType:@"Token"];
    }
    [super prepareRequest:networkRequest];
}

- (id)loginWithName:(NSString *)loginName password:(NSString *)password onSucceeded:(VoidBlock)succeededBlock onError:(ErrorBlock)errorBlock
{
    RESTfulOperation *op = (RESTfulOperation *)[self requestWithPath:@"loginwaiter"];
    [op setUsername:loginName];
    [op setPassword:password];
    NSString *base64EncodedString = [[[NSString stringWithFormat:@"%@:%@", loginName, password] dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    [op setAuthorizationHeaderValue:base64EncodedString forAuthType:@"Basic"];
    
    [op addCompletionHandler:^(MKNetworkRequest *completedRequest) {
        if (completedRequest.state == MKNKRequestStateCompleted) {
            NSDictionary *responseDict = [completedRequest responseAsJSON];
            NSLog(@"dict = %@", responseDict);
            self.accessToken = [responseDict objectForKey:@"accessToken"];
            NSLog(@"accessToken = %@", self.accessToken);
            succeededBlock();
        }
        else if(completedRequest.state == MKNKRequestStateError)
        {
            self.accessToken = nil;
            errorBlock(completedRequest.error);
        }
    }];
    [self startRequest:op];
    
    return op;
}

- (RESTfulOperation *)fetchMenuItemsSucceeded:(ArrayBlock)succeededBlock onError:(ErrorBlock)errorBlock
{
    RESTfulOperation *op  = (RESTfulOperation *)[self requestWithPath:@"menuitem"];
    [op addCompletionHandler:^(MKNetworkRequest *completedRequest) {
        if (completedRequest.state == MKNKRequestStateCompleted)
        {
            NSMutableDictionary *responseDictionary = [completedRequest responseAsJSON];
            NSLog(@"responseDictionary = %@", responseDictionary);
            NSMutableArray *menuItemsJson = [responseDictionary objectForKey:@"menuitems"];
            NSLog(@"menuItemJson = %@", menuItemsJson);
            
            NSMutableArray *menuItems = [NSMutableArray array];
            
            [menuItemsJson enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [menuItems addObject:[[MenuItem alloc] initWithDictionary:obj]];
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                 succeededBlock(menuItems);
            });
           
        }
        else if (completedRequest.state == MKNKRequestStateError)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                errorBlock(completedRequest.error);
            });
            
        }
    }];
    
    [self startRequest:op];
    
    return op;
}

- (RESTfulOperation *)fetchMenuItemsFromWrongLocationOnSucceeded:(ArrayBlock)succeededBlock onError:(ErrorBlock)errorBlock
{
    RESTfulOperation *op = (RESTfulOperation *)[self requestWithPath:@"404"];
    [op addCompletionHandler:^(MKNetworkRequest *completedRequest) {
        if (completedRequest.state == MKNKRequestStateCompleted)
        {
            NSMutableArray *responseArray = [completedRequest responseAsJSON];
            NSMutableArray *menuItems = [NSMutableArray array];
            
            [responseArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [menuItems addObject:[[MenuItem alloc] initWithDictionary:obj]];
            }];
            
            succeededBlock(menuItems);
        }
        else if (completedRequest.state == MKNKRequestStateError)
        {
            errorBlock(completedRequest.error);
        }
    }];
    
    [self startRequest:op];
    
    return op;
}

@end
