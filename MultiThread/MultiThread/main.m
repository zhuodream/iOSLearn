//
//  main.m
//  MultiThread
//
//  Created by 7road on 15/8/31.
//  Copyright (c) 2015年 7road. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        //DISPATCH_QUEUE_SERIAL顺序排列先进先出
        dispatch_queue_t seriouslyTeam=dispatch_queue_create("com.road.zhuo", DISPATCH_QUEUE_SERIAL);
        //DISPATCH_QUEUE_CONCURRENT同时执行
        dispatch_queue_t relaxingTeam=dispatch_queue_create("com.road.zhuo", DISPATCH_QUEUE_CONCURRENT);
        
        //异步执行，可以并发执行
        dispatch_async(relaxingTeam, ^{
            for(int i=0;i<=1000;i++)
            {
                NSLog(@"我是小A，宽松型，完成度 %%%.3f ----%@",i*0.1,[NSThread currentThread]);
            }
        });
        
        dispatch_async(relaxingTeam, ^{
            for(int i=0;i<=1000;i++)
            {
                NSLog(@"我是小B，宽松型，完成度 %%%.3f ----%@",i*0.1,[NSThread currentThread]);
            }
        });
        
        //同步执行，只能一件一件事的做
        dispatch_sync(seriouslyTeam, ^{
            for (int i=0; i<=1000; i++) {
                NSLog(@"我是小C，严格型，完成度 %%%.3f ----%@",i*0.1,[NSThread currentThread]);
            }
        });
        
        dispatch_async(relaxingTeam, ^{
            for (int i=0; i<=1000; i++) {
                NSLog(@"我是小D，宽松型，完成度 %%%.3f ----%@",i*0.1,[NSThread currentThread]);
            }
        });
        
        dispatch_sync(seriouslyTeam, ^{
            for (int i=0; i<=1000; i++) {
                NSLog(@"我是小E，严格型，完成度 %%%.3f ----%@",i*0.1,[NSThread currentThread]);
            }
        });
        
        
        
    }
    return 0;
}
