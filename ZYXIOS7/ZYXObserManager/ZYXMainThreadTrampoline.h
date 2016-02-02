//
//  ZYXMainThreadTrampoline.h
//  ZYXObserManager
//
//  Created by 7road on 15/12/22.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYXMainThreadTrampoline : NSObject

@property (nonatomic, readwrite, strong) id target;

- (id)initWithTarget:(id)aTarget;

@end
