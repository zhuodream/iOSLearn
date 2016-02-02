//
//  ViewController.h
//  ZYXNSURLSessionDownload
//
//  Created by 7road on 15/11/17.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic, strong) NSURLSession *currentSession;     //当前会话
@property (nonatomic, strong, readonly) NSURLSession *backgroundSession;    //后台回话

//下载任务
@property (nonatomic, strong) NSURLSessionDownloadTask *cancelableTask; //可取消的下载任务
@property (nonatomic, strong) NSURLSessionDownloadTask *resumeableTask; //可恢复的下载任务
@property (nonatomic, strong) NSURLSessionDownloadTask *backgroundTask; //后台的下载任务

//用于可恢复的下载任务的数据
@property (nonatomic, strong) NSData *partialData;

//显示已经下载的图片
@property (nonatomic, weak) IBOutlet UIImageView *downloadImageView;

@property (nonatomic, weak) IBOutlet UILabel *currentProgress_label;
@property (nonatomic, weak) IBOutlet UIProgressView *downloadingProgressView;

//工具栏上的按钮
@property (nonatomic, weak) IBOutlet UIBarButtonItem *cancelableDownload_barButtonItem;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *resumeableDownload_barButtonItem;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *backgroundableDownload_barButtonItem;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *cancelTask_barButtonItem;

- (IBAction)cancelableDownload:(id)sender;
- (IBAction)resumeableDownload:(id)sender;
- (IBAction)backgrounDownload:(id)sender;
- (IBAction)cancelDownloadTask:(id)sender;

@end

