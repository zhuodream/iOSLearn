//
//  ZYXObserverManager.h
//  ZYXObserManager
//
//  Created by 7road on 15/12/22.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface ZYXObserverManager : NSObject

- (id)initWithProtocol:(Protocol *)protocol observers:(NSSet *)observers;

- (void)addObserver:(id)observer;
- (void)removeObserver:(id)observer;

@end
