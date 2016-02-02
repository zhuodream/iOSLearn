//
//  ZYXKeyChain.h
//  ZYXKeyChain
//
//  Created by 7road on 16/1/11.
//  Copyright © 2016年 zhuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYXKeyChain : NSObject

+ (NSString *)getPasswordForUserName:(NSString *)username andServiceName:(NSString *)serviceName error:(NSError **)error;

+ (BOOL)storeUserName:(NSString *)username andPassword:(NSString *)password forServiceName:(NSString *)serviceName updateExisting:(BOOL)updateExisting error:(NSError **)error;

+ (BOOL)deleteItemForUsername:(NSString *)username andServiceName:(NSString *)serviceName error:(NSError **)error;

@end
