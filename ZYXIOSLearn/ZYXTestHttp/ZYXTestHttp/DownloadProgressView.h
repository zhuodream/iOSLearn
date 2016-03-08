//
//  DownloadProgressView.h
//  ZYXTestHttp
//
//  Created by 7road on 16/3/8.
//  Copyright © 2016年 zhuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kShowProgressView   @"showProgressView"
#define kHideProgressView   @"hideProgressView"

@interface DownloadProgressView : UIView

@property (nonatomic, weak) IBOutlet UIProgressView *progress;

@property (nonatomic, assign) BOOL hidden;

- (void)addAmountToDownload:(long long)amountToDownload;
- (void)addAmountDownloaded:(long long)amountDownloaded;

@end
