//
//  ViewController.m
//  ZYXMyKVO
//
//  Created by 7road on 15/12/21.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "KVCTableViewController.h"
#import "ZYXTimer.h"
#import "KVCTableViewCell.h"

@interface KVCTableViewController ()

@property (nonatomic, strong) ZYXTimer *timer;
@property (nonatomic, strong) NSDate *now;

@end

@implementation KVCTableViewController

- (void)updateNow
{
    self.now = [NSDate date];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    __weak id weakself = self;
    self.timer = [ZYXTimer repeatingTimerWithTimeInterval:1 block:^{
        [weakself updateNow];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"KVCTableViewCell";
    KVCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[KVCTableViewCell alloc] initWithReuseIdentifier:cellIdentifier];
        [cell setProperty:@"now"];
        [cell setObject:self];
    }
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
