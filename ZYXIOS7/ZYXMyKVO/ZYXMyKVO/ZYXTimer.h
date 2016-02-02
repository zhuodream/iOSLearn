//
//  ZYXTimer.h
//  ZYXMyKVO
//
//  Created by 7road on 15/12/21.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYXTimer : NSObject

+ (ZYXTimer *)repeatingTimerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(void))block;

- (void)fire;

- (void)invalidate;

@end
