//
//  BNRItemStore.h
//  Homepwner
//
//  Created by 7road on 15/7/23.
//  Copyright (c) 2015年 7road. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BNRItem;
@interface BNRItemStore : NSObject

@property (nonatomic,readonly) NSArray *allItems;


//声明类方法，单例模式
+(instancetype)sharedStore;
-(BNRItem *)createItem;
-(void)removeItem:(BNRItem *)item;
-(void)moveItemAtIndex:(NSUInteger)fromIndex
               toIndex:(NSUInteger)toIndex;

-(NSString *)itemArchivePath;

-(BOOL)saveChanges;

- (NSArray *)allAssetTypes;

@end
