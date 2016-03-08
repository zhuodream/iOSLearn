//
//  ViewController.m
//  ZYXTestHttp
//
//  Created by 7road on 16/3/8.
//  Copyright © 2016年 zhuo. All rights reserved.
//

#import "ViewController.h"
#import "AsyncDownloader.h"
#import "VideoCell.h"
#import "FeedLoader.h"
#import <MediaPlayer/MediaPlayer.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self refreshlist:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showProgress:) name:kShowProgressView object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideProgress:) name:kHideProgressView object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadComplete:) name:kDownloadComplete object:nil];
    
    [self hideProgress:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

- (IBAction)refreshlist:(id)sender
{
    self.videos = [NSArray array];
    
    NSString *feedURL = @"http://www.nasa.gov/rss/NASAcast_vodcast.rss";
    
    FeedLoader *feedLoader = [FeedLoader new];
    
    switch (self.segmentedcontrol.selectedSegmentIndex) {
        case 0 : // queued request
            [feedLoader doQueuedRequest:feedURL delegate:self];
            break;
        case 1 : // sync request
            self.videos = [feedLoader doSyncRequest:feedURL];
            break;
            
        default:
            break;
    }
    
    
}

- (void)showProgress:(NSNotification *)notification
{
    [UIView animateWithDuration:0.2 animations:^{
        CGFloat height = self.downloadprogressView.frame.size.height;
        CGRect oldFrame = self.downloadprogressView.frame;
        CGRect nf = CGRectMake(oldFrame.origin.x, oldFrame.origin.y - height, oldFrame.size.width, oldFrame.size.height);
        self.downloadprogressView.frame = nf;
        oldFrame = self.videotable.frame;
        nf = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, oldFrame.size.width, oldFrame.size.height - height);
        self.videotable.frame = nf;
        self.downloadprogressView.hidden = NO;
        [self.downloadprogressView layoutIfNeeded];
        [self.videotable layoutIfNeeded];
    }];
}

- (void)hideProgress:(NSNotification *)notification
{
    [UIView animateWithDuration:0.2 animations:^{
        CGFloat height = self.downloadprogressView.frame.size.height;
        CGRect oldFrame = self.downloadprogressView.frame;
        CGRect nf = CGRectMake(oldFrame.origin.x, oldFrame.origin.y + height, oldFrame.size.width, oldFrame.size.height);
        self.downloadprogressView.frame = nf;
        oldFrame = self.videotable.frame;
        nf = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, oldFrame.size.width, oldFrame.size.height + height);
        self.videotable.frame = nf;
        self.downloadprogressView.hidden = YES;
        [self.downloadprogressView layoutIfNeeded];
        [self.videotable layoutIfNeeded];
    }];
}

- (NSString *) getVideoURL:(NSDictionary *)entry {
    NSDictionary *enclosure = [entry objectForKey:@"enclosure"];
    NSString *url = [enclosure objectForKey:@"url"];
    
    return url;
    
}

- (void)downloadComplete:(NSNotification *)notification
{
    [self.videotable reloadData];
}

- (void)setVideos:(NSArray *)videos
{
    _videos = videos;
    [self.videotable reloadData];
}

- (NSString *) getVideoFilename:(NSDictionary *)entry {
    NSString *urlString = [self getVideoURL:entry];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSString *basePath = [url lastPathComponent];
    
    NSArray *pathList = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    NSString *docPath = [pathList  objectAtIndex:0];
    
    docPath = [docPath stringByAppendingPathComponent:basePath];
    
    return docPath;
}

- (BOOL)isFileDownloaded:(NSDictionary *)entry
{
    NSString *docPath = [self getVideoFilename:entry];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:docPath])
    {
        return YES;
    }
    else
    {
        return NO;
    }

}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIndentifier = @"VideoCell";
    
    VideoCell *cell = (VideoCell *)[tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"VideoCell" owner:self options:nil];
        cell = (VideoCell *)[nib objectAtIndex:0];
    }
    
    NSDictionary *entry = [self.videos objectAtIndex:indexPath.row];
    
    NSDictionary *titleDict = [entry objectForKey:@"title"];
    NSDictionary *descriptionDict = [entry objectForKey:@"description"];
    
    id title = [titleDict objectForKey:@"text"];
    cell.titlelabel.text = [title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    cell.desctiptionlabel.text = [[descriptionDict objectForKey:@"text"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([self isFileDownloaded:entry])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.videos count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 79.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *entry = [self.videos objectAtIndex:indexPath.row];
    
    if ([self isFileDownloaded:entry]) {
        // play video
        NSURL *videoURL = [NSURL fileURLWithPath:[self getVideoFilename:entry]];
        self.mp = [[MPMoviePlayerViewController alloc] initWithContentURL: videoURL];
        
        [self.mp shouldAutorotateToInterfaceOrientation:YES];
        
        [self presentMoviePlayerViewControllerAnimated:self.mp];
        
    } else {
        // start download
        NSString *url = [self getVideoURL:entry];
        NSString *filename = [self getVideoFilename:entry];
        
        AsyncDownloader *downloader = [AsyncDownloader new];
        
        downloader.srcURL = url;
        downloader.targetFile = filename;
        downloader.progressView = self.downloadprogressView;
        
        [downloader start];
        
    }
    
}

@end
