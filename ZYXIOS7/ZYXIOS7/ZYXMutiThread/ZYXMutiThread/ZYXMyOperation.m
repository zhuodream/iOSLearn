//
//  ZYXMyOperation.m
//  ZYXMutiThread
//
//  Created by 7road on 15/11/14.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "ZYXMyOperation.h"

@implementation ZYXMyOperation

- (void)main
{
    NSLog(@"线程执行的方法");
    [self performSelectorOnMainThread:@selector(printOnMain) withObject:nil waitUntilDone:YES];
}

- (void)printOnMain
{
    NSLog(@"在主线程上运行");
}

@end
