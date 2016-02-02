//
//  BNRImageStore.h
//  Homepwner
//
//  Created by 7road on 15/7/25.
//  Copyright (c) 2015年 7road. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BNRImageStore : NSObject

+(instancetype)sharedStore;

-(void)setImage:(UIImage *)image forKey:(NSString *)key;
-(UIImage *)imageForKey:(NSString *)key;
-(void)deleteImageForKey:(NSString *)key;

-(NSArray *)allAssetTypes;
@end
