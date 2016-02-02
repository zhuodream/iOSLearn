//
//  ViewController.m
//  ZYXNSURLSessionDownload
//
//  Created by 7road on 15/11/17.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController () <NSURLSessionDownloadDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.downloadingProgressView.hidden = YES;
    self.downloadingProgressView.progress = 0;
}



- (IBAction)cancelableDownload:(id)sender
{
    if (!self.cancelableTask)
    {
        if (!self.currentSession)
        {
            [self createCurrentSession];
        }
        NSString *imageURL= @"http://farm6.staticflickr.com/5505/9824098016_0e28a047c2_b_d.jpg";
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:imageURL]];
        self.cancelableTask = [self.currentSession downloadTaskWithRequest:request];
        
        
        [self setDownloadButtonAsEnable:NO];
        self.downloadImageView.image = nil;
        
        [self.cancelableTask resume];
    }
   
}

- (IBAction)cancelDownloadTask:(id)sender
{
    if (self.cancelableTask)
    {
        [self.cancelableTask cancel];
        self.cancelableTask = nil;
    }
    else if (self.resumeableTask)
    {
        [self.resumeableTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
            self.partialData = resumeData;
            self.resumeableTask = nil;
        }];
    }
    else if (self.backgroundTask)
    {
        [self.backgroundTask cancel];
        self.backgroundTask = nil;
    }
}

- (IBAction)resumeableDownload:(id)sender
{
    if (!self.resumeableTask)
    {
        if (self.currentSession)
        {
            NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
            self.currentSession = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
            self.currentSession.sessionDescription = @"in-process NSURLSession";
        }
        
        if (self.partialData)
        {
            self.resumeableTask = [self.currentSession downloadTaskWithResumeData:self.partialData];
        }
        else
        {
            NSString *url = @"http://farm3.staticflickr.com/2846/9823925914_78cd653ac9_b_d.jpg";
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
            self.resumeableTask = [self.currentSession downloadTaskWithRequest:request];
        }
        
        [self setDownloadButtonAsEnable:NO];
        self.downloadImageView.hidden = YES;
        
        [self.resumeableTask resume];
    }
}

- (IBAction)backgrounDownload:(id)sender
{
    NSString *url = @"http://farm3.staticflickr.com/2831/9823890176_82b4165653_b_d.jpg";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    self.backgroundTask = [self.backgroundSession downloadTaskWithRequest:request];
    
    [self setDownloadButtonAsEnable:NO];
    self.downloadImageView.image = nil;
    
    [self.backgroundTask resume];
}

//创建一个后台的session单例
- (NSURLSession *)backgroundSession
{
    static NSString *identify = @"background";
    static NSURLSession *backgroundSess = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:identify];
        backgroundSess = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
        backgroundSess.sessionDescription = @"background session";
    });
    
    return backgroundSess;
}

#pragma mark -Utility methods
- (void)setDownloadButtonAsEnable:(BOOL)enabled
{
    self.cancelableDownload_barButtonItem.enabled = enabled;
    self.resumeableDownload_barButtonItem.enabled = enabled;
    self.backgroundableDownload_barButtonItem.enabled = enabled;
}

- (void)createCurrentSession
{
    NSURLSessionConfiguration *defalutConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.currentSession = [NSURLSession sessionWithConfiguration:defalutConfig delegate:self delegateQueue:nil];
}

- (void)setDownloadProgress:(double)progress
{
    NSString *progressStr = [NSString stringWithFormat:@"%.1f", progress * 100];
    progressStr = [progressStr stringByAppendingString:@"%"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.downloadingProgressView.progress = progress;
        self.currentProgress_label.text = progressStr;
    });
}

#pragma mark - downloaddelegate
//下载成功会调用
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSLog(@"成功");
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *URLS = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentsDirctory = URLS[0];
    
    NSURL *destinationPath = [documentsDirctory URLByAppendingPathComponent:[location lastPathComponent]];
    
    NSError *error;
    [fileManager removeItemAtURL:destinationPath error:NULL];
    BOOL success = [fileManager copyItemAtURL:location toURL:destinationPath error:&error];
    if (success)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *image = [UIImage imageWithContentsOfFile:[destinationPath path]];
            self.downloadImageView.image = image;
            self.downloadImageView.contentMode = UIViewContentModeScaleAspectFill;
            self.downloadImageView.hidden = NO;
        });
    }
    else
    {
        NSLog(@"Couldn't copy the downloaded file");
    }
    
    if (downloadTask == self.cancelableTask)
    {
        self.cancelableTask = nil;
    }
    else if (downloadTask == self.resumeableTask)
    {
        self.resumeableTask = nil;
        self.partialData = nil;
    }
    else if (session == self.backgroundSession)
    {
        self.backgroundTask = nil;
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (appDelegate.backgroundURLSessionCompletionHandler)
        {
            void(^handler)() = appDelegate.backgroundURLSessionCompletionHandler;
            appDelegate.backgroundURLSessionCompletionHandler = nil;
            handler();
        }
    }
}


//下载进度的显示
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    
    //计算当前下载进度并更新视图
    double downloadProgress = totalBytesWritten / (double)totalBytesExpectedToWrite;

    [self setDownloadProgress:downloadProgress];

}

//不管下载成功还是失败都会调用
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    NSLog(@"成功或者失败");
    dispatch_async(dispatch_get_main_queue(), ^{
        self.downloadingProgressView.hidden = YES;
        [self setDownloadButtonAsEnable:YES];
    });
}

@end
