//
//  ViewController.m
//  ZYXProducerConsumer
//
//  Created by 7road on 15/12/21.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "ViewController.h"

static const char sQueueTagKey;

@interface ViewController ()

@property (strong, nonatomic) IBOutletCollection(UIProgressView) NSArray *progressviews;

@property (nonatomic, strong) IBOutlet UILabel *queueLabel;
@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@property (nonatomic, strong) dispatch_queue_t pendingQueue;
@property (nonatomic, strong) dispatch_queue_t workQueue;

@property (nonatomic, assign) NSInteger _pendingCount;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.semaphore = dispatch_semaphore_create([self.progressviews count]);
    NSLog(@"progressViews count ==== %ld", [self.progressviews count]);
    
    self.pendingQueue = dispatch_queue_create("ProducerConsumer.pending", DISPATCH_QUEUE_SERIAL);
    //给当前队列做一个标记
    dispatch_queue_set_specific(self.pendingQueue, &sQueueTagKey, (__bridge void *)self.pendingQueue, NULL);
     NSLog(@"%p", self.pendingQueue);
    
    self.workQueue = dispatch_queue_create("ProducerConsumer.work", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_set_specific(self.workQueue, &sQueueTagKey, (__bridge void*)self.workQueue, NULL);
    NSLog(@"%p", self.workQueue);
   
}

- (void)adjustPendingJobCountBy:(NSInteger)value
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self._pendingCount += value;
        self.queueLabel.text = [NSString stringWithFormat:@"%ld", self._pendingCount];
    });
}

- (UIProgressView *)reserveProgressView
{
    dispatch_queue_t q = (__bridge dispatch_queue_t)dispatch_get_specific(&sQueueTagKey);
    BOOL isPendingQueue = (q == self.pendingQueue);
    NSAssert(isPendingQueue, @"Must run on pendingQueue");
    
    __block UIProgressView *availableProgressView;
    dispatch_sync(dispatch_get_main_queue(), ^{
        for (UIProgressView *progressView in self.progressviews)
        {
            if (progressView.isHidden)
            {
                availableProgressView = progressView;
                NSLog(@"aaaaaaa");
                break;
            }
        }
        availableProgressView.hidden = NO;
        availableProgressView.progress = 0;
    });
    
    NSAssert(availableProgressView, @"There should always be one avaliable here.");
    return availableProgressView;
}

- (void)releaseProgressView:(UIProgressView *)progressView
{
    dispatch_queue_t q = (__bridge dispatch_queue_t)dispatch_get_specific(&sQueueTagKey);
    BOOL isWorkQueue = (q == self.workQueue);
    
    NSAssert(isWorkQueue, @"Must run on workQueue");
    
    dispatch_async(dispatch_get_main_queue(), ^{
        progressView.hidden = YES;
    });
}

- (IBAction)runProgress:(UIButton *)proButton
{
    NSAssert([NSThread isMainThread], @"Must run on main queue");
    dispatch_queue_t q = (__bridge dispatch_queue_t)dispatch_get_specific(&sQueueTagKey);
    NSLog(@"%p", q);
    [self adjustPendingJobCountBy:1];
    dispatch_async(self.pendingQueue, ^{
        //等待信号量
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        
        UIProgressView *availableProgressView = [self reserveProgressView];
        
        dispatch_async(self.workQueue, ^{
            [self performWorkWithProgressView:availableProgressView];
            
            [self releaseProgressView:availableProgressView];
            
            [self adjustPendingJobCountBy:-1];
            
            dispatch_semaphore_signal(self.semaphore);
        });
    });
}

- (void)performWorkWithProgressView:(UIProgressView *)progressView {
    dispatch_queue_t q = (__bridge dispatch_queue_t)dispatch_get_specific(&sQueueTagKey);
    BOOL isWorkQueue = (q == self.workQueue);
    
    NSAssert(isWorkQueue, @"Must run on workQueue");
    
    for (NSUInteger p = 0; p <= 100; ++p) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            progressView.progress = p/100.0;
        });
        usleep(50000);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
