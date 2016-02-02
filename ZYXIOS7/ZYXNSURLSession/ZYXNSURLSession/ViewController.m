//
//  ViewController.m
//  ZYXNSURLSession
//
//  Created by 7road on 15/11/16.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)loadData:(id)sender
{
    //开始加载数据，spinner转动
    [self.spinner startAnimating];
    
    //创建Data Task
    NSURL *url = [NSURL URLWithString:@"http://blog.csdn.net/u010962810"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [self showResponseCode:response];
        
        //在webview中加载数据
        [self.webView loadData:data MIMEType:@"text/html" textEncodingName:@"utf-8" baseURL:nil];
        //加载数据完毕，停止转动
        [self.spinner stopAnimating];
    }];
    [dataTask resume];
}

- (void)showResponseCode:(NSURLResponse *)response
{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSInteger responseStatusCode = [httpResponse statusCode];
    NSLog(@"%ld", responseStatusCode);
}

- (IBAction)downloadFile:(id)sender
{
    [self.spinner startAnimating];
    
    NSURL *url = [NSURL URLWithString:@"http://b.hiphotos.baidu.com/image/w%3D2048/sign=6be5fc5f718da9774e2f812b8469f919/8b13632762d0f703b0faaab00afa513d2697c515.jpg"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [self showResponseCode:response];
        NSString *path = [self getDocumentPath];
        NSLog(@"PATH = %@", path);
        NSLog(@"LOCATION = %@", location);
        NSURL *documentURL = [NSURL fileURLWithPath:path];
        NSLog(@"documenURL = %@", documentURL);
        NSURL *fileURL = [documentURL URLByAppendingPathComponent:[[response URL] lastPathComponent]];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:[fileURL path]]) {
            [[NSFileManager defaultManager] removeItemAtURL:fileURL error:NULL];
        }
        [[NSFileManager defaultManager] moveItemAtURL:location toURL:fileURL error:NULL];
        
        
        [self.webView loadRequest:[NSURLRequest requestWithURL:fileURL]];
        
        [self.spinner stopAnimating];
    }];
    
    
    [downloadTask resume];
}

- (IBAction)uploadFile:(id)sender
{
}

- (NSString *)getDocumentPath
{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    
    return path;
}
@end
