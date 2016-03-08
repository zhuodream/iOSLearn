//
//  DownloadProgressView.m
//  ZYXTestHttp
//
//  Created by 7road on 16/3/8.
//  Copyright © 2016年 zhuo. All rights reserved.
//

#import "DownloadProgressView.h"

@interface DownloadProgressView()

@property (nonatomic, assign) long long amountToDownload;
@property (nonatomic, assign) long long amountDownloaded;

@end

@implementation DownloadProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    
    return self;
}

- (void)adjustProgressBar
{
    float progress = (float)self.amountDownloaded/(float)self.amountToDownload;
    [self.progress setProgress:progress animated:YES];
    
    if (self.amountDownloaded == self.amountToDownload)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kHideProgressView object:nil];
        self.hidden = YES;
        self.amountDownloaded = 0L;
        self.amountToDownload = 0L;
    }
    else if (self.hidden)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kShowProgressView object:nil];
    }
}

- (void)addAmountToDownload:(long long)amountToDownload
{
    @synchronized(self)
    {
        self.amountToDownload += amountToDownload;
    }
    [self adjustProgressBar];
}

- (void)addAmountDownloaded:(long long)amountDownloaded
{
    @synchronized(self)
    {
        self.amountDownloaded += amountDownloaded;
    }
    [self adjustProgressBar];
}


@end
