//
//  ViewController.m
//  ZYXTestBack
//
//  Created by 7road on 16/3/7.
//  Copyright © 2016年 zhuo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSMutableURLRequest *request;
@property (nonatomic, strong) NSURLCache *urlCache;
@property (nonatomic, strong) NSRunLoop *runloop;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:0 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    self.urlCache = URLCache;
    // Do any additional setup after loading the view, typically from a nib.
    NSString *str = @"http://www.7road.com/accounts/checklogin";
    NSURL *url = [NSURL URLWithString:str];
    self.request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0f];
//    [self.request setValue:@"e3686b717a49b241c6e1680d02df1681" forHTTPHeaderField:@"apikey"];
   // NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    [NSURLConnection sendAsynchronousRequest:self.request queue:queue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
//        NSLog(@"response = %@", response);
//        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"string = %@", string);
//    }];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//       
//        NSRunLoop *runloop = [NSRunLoop currentRunLoop];
//        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self startImmediately:NO];
//        
//        [connection scheduleInRunLoop:runloop forMode:NSDefaultRunLoopMode];
//        
//        [connection start];
//        [runloop run];
//        
//        NSLog(@"runloop= %@", runloop);
//    });
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self];
    [connection setDelegateQueue:[[NSOperationQueue alloc] init]];
        [connection start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)httpacess:(id)sender
{
    NSCachedURLResponse *response =[self.urlCache cachedResponseForRequest:self.request];
    //判断是否有缓存
    if (response != nil){
        NSLog(@"如果有缓存输出，从缓存中获取数据");
        [self.request setCachePolicy:NSURLRequestReturnCacheDataDontLoad];
    }
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    [NSURLConnection sendAsynchronousRequest:self.request queue:queue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
//        NSLog(@"response = %@", response);
//        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"string = %@", string);
//    }];
    [NSURLConnection connectionWithRequest:self.request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"thread = %@", [NSThread currentThread]);
    NSLog(@"resopnse ========== %@", response);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"接收到数据长度 ＝ %ld", [data length]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"完成");
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse *)cachedResponse{
    NSLog(@"将缓存输出");
    return(cachedResponse);
}

@end
