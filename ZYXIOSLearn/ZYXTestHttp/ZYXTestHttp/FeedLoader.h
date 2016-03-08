//
//  FeedLoader.h
//  ZYXTestHttp
//
//  Created by 7road on 16/3/8.
//  Copyright © 2016年 zhuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedLoader : NSObject

- (NSArray *)doSyncRequest:(NSString *)urlString;
- (void) doQueuedRequest:(NSString *)urlString delegate:(id)delegate;

@end
