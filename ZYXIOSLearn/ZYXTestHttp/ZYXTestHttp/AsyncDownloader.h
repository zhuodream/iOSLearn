//
//  AsyncDownloader.h
//  ZYXTestHttp
//
//  Created by 7road on 16/3/8.
//  Copyright © 2016年 zhuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadProgressView.h"

#define kDownloadComplete   @"downloadComplete"

@interface AsyncDownloader : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic, assign) long long downloadSize;
@property (nonatomic, assign) long long totalDownloaded;
@property (nonatomic, weak) DownloadProgressView *progressView;
@property (nonatomic, strong) NSString *targetFile;
@property (nonatomic, strong) NSString *srcURL;
@property (nonatomic, strong) NSFileHandle *outputHandle;
@property (nonatomic, strong) NSString *tempFile;
@property (nonatomic, strong) NSURLConnection *conn;

- (void)start;

@end
