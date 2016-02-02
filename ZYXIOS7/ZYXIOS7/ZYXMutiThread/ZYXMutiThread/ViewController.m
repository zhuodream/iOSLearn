//
//  ViewController.m
//  ZYXMutiThread
//
//  Created by 7road on 15/11/14.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "ViewController.h"
#import "ZYXMyOperation.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(printSomthing:) object:nil];
//    ZYXMyOperation *operation = [[ZYXMyOperation alloc] init];
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    [queue addOperation:operation];
//    NSBlockOperation *blocOperation = [NSBlockOperation blockOperationWithBlock:^{
//        NSLog(@"block operation");
//    }];
//    [blocOperation start];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSLog(@"dispatch 线程");
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSLog(@"线程执行完毕，进入主线程");
//        });
//    });
//    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSLog(@"线程同步");
//        [NSThread sleepForTimeInterval:2];
//        NSLog(@"333");
//    });
    dispatch_queue_t queue = dispatch_queue_create("com.zhuo.thread", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group  = dispatch_group_create();
//    dispatch_group_async(group, queue, ^{
//        NSLog(@"group线程1");
//    });
//    dispatch_group_async(group, queue, ^{
//        NSLog(@"group线程2");
//    });
//    
//    dispatch_group_notify(group, queue, ^{
//        NSLog(@"线程执行完毕");
//    });
//
    dispatch_async(queue, ^{
        dispatch_group_enter(group);
        dispatch_sync(queue, ^{
            NSLog(@"group线程");
            NSLog(@"current thread = %@", [NSThread currentThread]);
            
        });
        dispatch_group_leave(group);
    });
    
    NSLog(@"主线程");
    
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"aaaaaaa");
}

- (void)printSomthing:(id)sender
{
    NSLog(@"进入线程");
    [self performSelectorOnMainThread:@selector(printOnMain) withObject:nil waitUntilDone:YES];
}

- (void)printOnMain
{
    NSLog(@"主线程");
}


@end
