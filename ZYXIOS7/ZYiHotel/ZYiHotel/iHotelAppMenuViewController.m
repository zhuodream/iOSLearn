//
//  iHotelAppMenuViewController.m
//  ZYiHotel
//
//  Created by 7road on 15/11/24.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "iHotelAppMenuViewController.h"
#import "AppDelegate.h"
#import "MenuItem.h"


@interface iHotelAppMenuViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *menuItems;
//@property (strong, nonatomic) UITableView *tableView;

@end

@implementation iHotelAppMenuViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = NSLocalizedString(@"Menu", @"");
//     _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
//    self.tableView.dataSource = self;
//    self.tableView.delegate = self;
//   
//    [self.view addSubview:_tableView];
    
//    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
//        
//        [[UIDevice currentDevice] performSelector:@selector(setOrientation:)
//         
//                                       withObject:@(UIPrintInfoOrientationLandscape)];
//        
//    }
//    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
//        SEL selector = NSSelectorFromString(@"setOrientation:");
//        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
//        [invocation setSelector:selector];
//        [invocation setTarget:[UIDevice currentDevice]];
//        int val = UIInterfaceOrientationLandscapeRight;
//        [invocation setArgument:&val atIndex:2];
//        [invocation invoke];
//    }
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"menuViewcontroller willappear = %@", self);
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [super viewWillAppear:animated];
    
//    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
//        SEL selector = NSSelectorFromString(@"setOrientation:");
//        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
//        [invocation setSelector:selector];
//        [invocation setTarget:[UIDevice currentDevice]];
//        int val = UIInterfaceOrientationLandscapeRight;
//        [invocation setArgument:&val atIndex:2];
//        [invocation invoke];
//        NSLog(@"转屏");
//    }
    
    [((AppDelegate *)[UIApplication sharedApplication].delegate).engine fetchMenuItemsSucceeded:^(NSMutableArray *listofModelBaseObjects) {
        self.menuItems = listofModelBaseObjects;
        [self.tableView reloadData];
    } onError:^(NSError *engineError) {
        [UIAlertView showWithError:engineError];
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"menuViewController willdisappear");

    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSLog(@"menuViewcontroller disappeared");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    NSLog(@"menu 支持的方向");
    return UIInterfaceOrientationMaskLandscapeRight;
}

//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//    NSLog(@"menu 的controller方向");
//    return UIInterfaceOrientationLandscapeRight;
//}

- (BOOL)shouldAutorotate
{
    NSLog(@"menu 是否支持旋转");
    return YES;
}

#pragma mark - tableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    MenuItem *item = [self.menuItems objectAtIndex:indexPath.row];
    cell.textLabel.text = item.name;
    NSLog(@"cellname =  == =  %@", item.name);
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击");
}


@end
