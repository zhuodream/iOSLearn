//
//  Products.h
//  ZYXSearch
//
//  Created by 7road on 15/10/19.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Products : NSObject <NSCoding>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *hardwareType;
@property (nonatomic, copy) NSNumber *yearIntroduced;
@property (nonatomic, copy) NSNumber *introPrice;

+ (Products *)productWithType:(NSString *)type name:(NSString *)name year:(NSNumber *)year price:(NSNumber *)price;

+ (NSArray *)deviceTypeNames;
+ (NSString *)displayNameForType:(NSString *)type;

+ (NSString *)deviceTypeTitle;

+ (NSString *)destktopTypeTitle;
+ (NSString *)portableTypeTitle;

@end
