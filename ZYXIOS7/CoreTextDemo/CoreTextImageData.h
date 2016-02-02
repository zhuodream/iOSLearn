//
//  CoreTextImageData.h
//  CoreTextDemo
//
//  Created by 7road on 15/12/31.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreTextImageData : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) int position;

//此坐标是CoreText坐标系，而不是UIKit坐标系
@property (nonatomic) CGRect imagePosition;

@end
