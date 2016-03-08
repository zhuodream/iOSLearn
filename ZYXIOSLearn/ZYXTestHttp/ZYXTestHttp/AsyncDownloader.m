//
//  AsyncDownloader.m
//  ZYXTestHttp
//
//  Created by 7road on 16/3/8.
//  Copyright © 2016年 zhuo. All rights reserved.
//

#import "AsyncDownloader.h"

@implementation AsyncDownloader

- (void)start
{
    NSLog(@"Starting to download %@", self.srcURL);
    
    NSURL *url = [NSURL URLWithString:self.srcURL];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    self.conn = [NSURLConnection connectionWithRequest:request delegate:self];
    
    [self.conn start];
}

- (NSString *)createUUID
{
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)uuidStringRef];
    CFRelease(uuidStringRef);
    
    return uuid;
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
    NSLog(@"Redirect request for %@ redicting to %@", self.srcURL, request.URL);
    NSLog(@"All headers = %@", [(NSHTTPURLResponse *)response allHeaderFields]);
    
    return request;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Received response from request to url %@",self.srcURL);
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    
    NSLog(@"All headers = %@", [httpResponse allHeaderFields]);
    
    if (httpResponse.statusCode != 200)
    {
        if (self.downloadSize != 0L)
        {
            [self.progressView addAmountDownloaded:-self.downloadSize];
            [self.progressView addAmountDownloaded:-self.totalDownloaded];
        }
        [connection cancel];
        return;
    }
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if (self.tempFile != nil)
    {
        [self.outputHandle closeFile];
        NSError *error;
        [fm removeItemAtPath:self.tempFile error:&error];
    }
    
    NSError *error;
    [fm removeItemAtPath:self.targetFile error:&error];
    
    NSString *tempDir = NSTemporaryDirectory();
    self.tempFile = [tempDir stringByAppendingPathComponent:[self createUUID]];
    NSLog(@"Writing content to %@", self.tempFile);
    
    [fm createFileAtPath:self.tempFile contents:nil attributes:nil];
    self.outputHandle = [NSFileHandle fileHandleForWritingAtPath:self.tempFile];
    
    NSString *contentLengthString = [[httpResponse allHeaderFields] objectForKey:@"Content-length"];
    if (self.downloadSize != 0L)
    {
        [self.progressView addAmountToDownload:-self.downloadSize];
        [self.progressView addAmountDownloaded:-self.totalDownloaded];
    }
    self.downloadSize = [contentLengthString longLongValue];
    self.totalDownloaded = 0L;
    
    [self.progressView addAmountToDownload:self.downloadSize];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    self.totalDownloaded += [data length];
    
    NSLog(@"Received %lld of %lld (%f%%) bytes of data for URL %@", self.totalDownloaded, self.downloadSize, ((double)self.totalDownloaded/(double)self.downloadSize)*100.0, self.srcURL);
    
    [self.progressView addAmountDownloaded:[data length]];
    
    [self.outputHandle writeData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Load failed with error %@", [error localizedDescription]);
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if (self.tempFile != nil)
    {
        [self.outputHandle closeFile];
        NSError *error;
        [fm removeItemAtPath:self.tempFile error:&error];
    }
    
    if (self.downloadSize != 0L)
    {
        [self.progressView addAmountToDownload:-self.downloadSize];
        [self.progressView addAmountDownloaded:-self.totalDownloaded];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self.outputHandle closeFile];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error;
    [fm moveItemAtPath:self.tempFile toPath:self.targetFile error:&error];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kDownloadComplete object:nil userInfo:nil];
}

@end
