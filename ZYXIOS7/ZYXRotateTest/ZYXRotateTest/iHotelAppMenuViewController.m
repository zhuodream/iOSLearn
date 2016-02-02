//
//  iHotelAppMenuViewController.m
//  ZYiHotel
//
//  Created by 7road on 15/11/24.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "iHotelAppMenuViewController.h"
#import "AppDelegate.h"



@interface iHotelAppMenuViewController () <UITableViewDelegate, UITableViewDataSource>

//@property (nonatomic, weak) IBOutlet UITableView *tableView;
//@property (strong, nonatomic) NSArray *menuItems;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation iHotelAppMenuViewController

//- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self)
//    {
//        
//    }
//    
//    return self;
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView = [[UITableView alloc] init];
    [self.view addSubview:_tableView];
   
    //self.title = NSLocalizedString(@"Menu", @"");
    
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
    NSLog(@"b视图将出现 = %@", self);
    [super viewWillAppear:animated];
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationLandscapeRight;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
        NSLog(@"转屏");
    }
    
//    [((AppDelegate *)[UIApplication sharedApplication].delegate).engine fetchMenuItemsSucceeded:^(NSMutableArray *listofModelBaseObjects) {
//        self.menuItems = listofModelBaseObjects;
//        [self.tableView reloadData];
//    } onError:^(NSError *engineError) {
//        [UIAlertView showWithError:engineError];
//    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"b视图将要消失");
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
        NSLog(@"转屏");
    }

}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSLog(@"B视图消失");
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

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    NSLog(@"menu 的controller方向");
    return UIInterfaceOrientationLandscapeRight;
}

- (BOOL)shouldAutorotate
{
    NSLog(@"menu 是否支持旋转");
    return NO;
}

#pragma mark - tableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return self.menuItems.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *cellIdentifier = @"Cell";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    
//    if (cell == nil)
//    {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//    }
//    
//    MenuItem *item = [self.menuItems objectAtIndex:indexPath.row];
//    cell.textLabel.text = item.name;
//    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
//    return cell;
//}
//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击");
}


@end
