//
//  ZYXKeyChain.m
//  ZYXKeyChain
//
//  Created by 7road on 16/1/11.
//  Copyright © 2016年 zhuo. All rights reserved.
//

#import "ZYXKeyChain.h"

@implementation ZYXKeyChain

+ (BOOL)storeUserName:(NSString *)username andPassword:(NSString *)password forServiceName:(NSString *)serviceName updateExisting:(BOOL)updateExisting error:(NSError *__autoreleasing *)error
{
    if (!username || !password || !serviceName)
    {
        if (error != nil)
        {
            *error = [NSError errorWithDomain:@"ZYXDomainError" code:-2000 userInfo:nil];
        }
        
        return NO;
    }
    
    NSError *getError = nil;
    //可能存在一种有账户保存，但没有对应密码保存的状况，此时应删除该状况，并重新设置
    NSString *existingPassword = [ZYXKeyChain getPasswordForUserName:username andServiceName:serviceName error:&getError];
    if ([getError code] == -1999)
    {
        NSLog(@"ccccccccccccccc");
        getError = nil;
        [self deleteItemForUsername:username andServiceName:serviceName error:&getError];
        if([getError code] != noErr)
        {
            if (error != nil)
            {
                *error = getError;
            }
        }
    }
    else if ([getError code] != noErr)
    {
        if (error != nil)
        {
            *error = getError;
        }
        return NO;
    }
    
    if (error != nil)
    {
        *error = nil;;
    }
    
    OSStatus status = noErr;
    
    if (existingPassword)
    {
        NSLog(@"aaaaaaaaaa");
        //如果keychain中存在一个password，则需要更新，先判断密码是否相同
        if (![existingPassword isEqualToString:password] && updateExisting)
        {
            //只有当允许更新的时候才更新
            NSArray *keys = [[NSArray alloc] initWithObjects:(NSString *)kSecClass,
                             kSecAttrService,
                             kSecAttrLabel,
                             kSecAttrAccount,nil];
            
            NSArray *objects = [[NSArray alloc] initWithObjects:(NSString *)kSecClassGenericPassword,
                serviceName,
                serviceName,
                username,nil];
            
            NSDictionary *query = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
            
            status = SecItemUpdate((CFDictionaryRef)query, (CFDictionaryRef)[NSDictionary dictionaryWithObject:[password dataUsingEncoding:NSUTF8StringEncoding] forKey:(NSString *)kSecValueData]);
            
        }
    }
    else
    {
        NSLog(@"bbbbbbbbbbbbb");
        NSArray *keys = [[NSArray alloc] initWithObjects:(NSString *)kSecClass,
                         kSecAttrService,
                         kSecAttrLabel,
                         kSecAttrAccount,
                         kSecValueData, nil];
        NSArray *objects = [[NSArray alloc] initWithObjects:(NSString *)kSecClassGenericPassword,
            serviceName,
            serviceName,
                            username,
                            [password dataUsingEncoding:NSUTF8StringEncoding], nil];
        NSDictionary *query = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
        
        status = SecItemAdd((CFDictionaryRef)query, NULL);
    }
    
    if (status != noErr)
    {
        NSLog(@"status = %d", status);
        if (error != nil)
        {
            *error = [NSError errorWithDomain:@"ZYXDomainError" code:status userInfo:nil];
        }
        return NO;
    }
    
    return YES;
}

+ (BOOL)deleteItemForUsername:(NSString *)username andServiceName:(NSString *)serviceName error:(NSError *__autoreleasing *)error
{
    if (!username || !serviceName)
    {
        if (error != nil)
        {
            *error = [NSError errorWithDomain:@"ZYXDomainError" code:-2000 userInfo:nil];
        }
        return NO;
    }
    
    if (error != nil)
    {
        *error = nil;
    }
    
    NSArray *keys = [[NSArray alloc] initWithObjects:(NSString *)kSecClass,
                    kSecAttrAccount,
                     kSecAttrService,
                     kSecReturnAttributes, nil];
    NSArray *objects = [[NSArray alloc] initWithObjects:(NSString *)kSecClassGenericPassword,
                        username,
                        serviceName,
                        kCFBooleanTrue, nil];
    
    NSDictionary *query = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
    
    OSStatus status = SecItemDelete((CFDictionaryRef)query);
    
    if (status != noErr)
    {
        if (error != nil)
        {
            *error = [NSError errorWithDomain:@"ZYXDomainError" code:status userInfo:nil];
        }
        return NO;
    }
    
    return YES;
}

+ (NSString *)getPasswordForUserName:(NSString *)username andServiceName:(NSString *)serviceName error:(NSError *__autoreleasing *)error
{
    if (!username || !serviceName)
    {
        if (error != nil)
        {
            *error = [NSError errorWithDomain:@"ZYXDomainError" code:-2000 userInfo:nil];
        }
        return nil;
    }
    
    if (error != nil)
    {
        *error = nil;
    }
    
    //先查找是否存在只有账户没有密码保存的情况
    NSArray *keys = [[NSArray alloc] initWithObjects:(NSString *)kSecClass,
                     kSecAttrAccount,
                     kSecAttrService,nil];
    NSArray *objects = [[NSArray alloc] initWithObjects:(NSString *)kSecClassGenericPassword,
                        username,
                        serviceName, nil];
    NSMutableDictionary *query = [[NSMutableDictionary alloc] initWithObjects:objects forKeys:keys];
    
    NSDictionary *attributeResult = nil;
    NSMutableDictionary *attributeQuery = [query mutableCopy];
    [attributeQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnAttributes];
    CFTypeRef attributeResultRef = (__bridge CFTypeRef)attributeResult;
    OSStatus status = SecItemCopyMatching((CFDictionaryRef) attributeQuery, &attributeResultRef);
    
    if (status != noErr)
    {
        NSLog(@"查询出现错误");
        if (error != nil && status != errSecItemNotFound)
        {
            *error = [NSError errorWithDomain:@"ZYXDomainError" code:status userInfo:nil];
        }
        
        return nil;
    }
    
    //存在该账户，现在来查询密码是否存在
    //NSData *resultData = nil;
    NSMutableDictionary *passwordQuery = [query mutableCopy];
    [passwordQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    
    
    CFTypeRef resultRef = NULL;
   
    //CFTypeRef resultRef = (__bridge_retained CFTypeRef)resultData;
    status = SecItemCopyMatching((CFDictionaryRef)passwordQuery, &resultRef);
    
    if (status != noErr)
    {
        if (status == errSecItemNotFound)
        {
            NSLog(@"没有找到密码，出现错误");
            //没有找到密码，出现错误
            if (error != nil)
            {
                *error = [NSError errorWithDomain:@"ZYXDomainError" code:-1999 userInfo:nil];
            }
        }
        else if (error != nil)
        {
            *error = [NSError errorWithDomain:@"ZYXDomainError" code:status userInfo:nil];
        }
    }
    NSLog(@"resyltref = %p", resultRef);
    NSLog(@"找到密码");
    NSString *password = nil;
    CFShow(resultRef);
    //resultData = (__bridge NSData *)resultRef;
    NSData *resultData = CFBridgingRelease(resultRef);
 
    if (resultData)
    {
        password = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
        NSLog(@"password = %@", password);
    }
    else if (error != nil)
    {
        *error = [NSError errorWithDomain:@"ZYXDomainError" code:-1999 userInfo:nil];
    }
    
    return password;
}


@end
