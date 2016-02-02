//
//  BNRItem.h
//  Homepwner
//
//  Created by 7road on 15/8/3.
//  Copyright (c) 2015年 7road. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@class NSManagedObject;

@interface BNRItem : NSManagedObject

@property (nonatomic, retain) NSString * itemName;
@property (nonatomic, retain) NSString * serialNumber;
@property (nonatomic) int  valueInDollars;
@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) NSString * itemKey;
@property (nonatomic, strong) UIImage * thumbnail;
@property (nonatomic) double  orderingValue;
@property (nonatomic, retain) NSManagedObject *assetType;

-(void)setThumbnailFromImage:(UIImage *)image;

@end
