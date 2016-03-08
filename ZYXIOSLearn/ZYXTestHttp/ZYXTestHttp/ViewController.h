//
//  ViewController.h
//  ZYXTestHttp
//
//  Created by 7road on 16/3/8.
//  Copyright © 2016年 zhuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadProgressView.h"
//#import <MediaPlayer/MediaPlayer.h>
@class MPMoviePlayerViewController;

@interface ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *videotable;
@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentedcontrol;
@property (nonatomic, weak) IBOutlet DownloadProgressView *downloadprogressView;
@property (nonatomic, strong) NSArray *videos;
@property (nonatomic, strong) MPMoviePlayerViewController *mp;

- (IBAction)refreshlist:(id)sender;


@end

