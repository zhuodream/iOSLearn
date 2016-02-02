//
//  Products.m
//  ZYXSearch
//
//  Created by 7road on 15/10/19.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "Products.h"

@implementation Products

+ (Products *)productWithType:(NSString *)type name:(NSString *)name year:(NSNumber *)year price:(NSNumber *)price
{
    Products *newProduct = [[self alloc] init];
    newProduct.hardwareType = type;
    newProduct.title = name;
    newProduct.yearIntroduced = year;
    newProduct.introPrice = price;
    
    return newProduct;
}

+ (NSString *)deviceTypeTitle
{
    return NSLocalizedString(@"Device", @"Device type title");
}

+ (NSString *)destktopTypeTitle
{
    return NSLocalizedString(@"Desktop", @"Desktop type title");
}

+ (NSString *)portableTypeTitle
{
    return NSLocalizedString(@"Portable", @"Portable type title");
}

+ (NSArray *)deviceTypeNames
{
    static NSArray * devieceTypeNames = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        devieceTypeNames = @[[Products destktopTypeTitle], [Products portableTypeTitle], [Products destktopTypeTitle]];
    });
    
    return devieceTypeNames;
}

+ (NSString *)displayNameForType:(NSString *)type
{
    static NSMutableDictionary *devieceTypeDisplayNamesDictionary = nil;
    static dispatch_once_t once;
    
    dispatch_once(&once,^{
        devieceTypeDisplayNamesDictionary = [[NSMutableDictionary alloc] init];
        for (NSString * deviceType in self.deviceTypeNames) {
            NSString *displayName = NSLocalizedString(deviceType, @"dynamic");
            devieceTypeDisplayNamesDictionary[deviceType] = displayName;
        }
    });
    
    return devieceTypeDisplayNamesDictionary[type];
    
}


#pragma mark - Encoding/Decoding

NSString *const NameKey = @"NameKey";
NSString *const TypeKey = @"TypeKey";
NSString *const YearKey = @"YearKey";
NSString *const PriceKey = @"PriceKey";

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _title = [aDecoder decodeObjectForKey:NameKey];
        _hardwareType = [aDecoder decodeObjectForKey:TypeKey];
        _yearIntroduced = [aDecoder decodeObjectForKey:YearKey];
        _introPrice = [aDecoder decodeObjectForKey:PriceKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.title forKey:NameKey];
    [aCoder encodeObject:self.hardwareType forKey:TypeKey];
    [aCoder encodeObject:self.yearIntroduced forKey:YearKey];
    [aCoder encodeObject:self.introPrice forKey:PriceKey];
}


@end