//
//  iHotelAppViewController.m
//  ZYiHotel
//
//  Created by 7road on 15/11/23.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "iHotelAppViewController.h"

#import "iHotelAppMenuViewController.h"

@interface iHotelAppViewController ()



@end

@implementation iHotelAppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"iHotel App Demo";
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"A视图将出现");
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"A视图出现");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)loginButtonTapped:(id)sender
{
//    [((AppDelegate *)[UIApplication sharedApplication].delegate).engine loginWithName:@"mugunth" password:@"abracadabra" onSucceeded:^{
//        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Success", @"") message:NSLocalizedString(@"Login successful", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Dismiss", @"") otherButtonTitles:nil] show];
//    } onError:^(NSError *engineError) {
//        [UIAlertView showWithError:engineError];
//    }];
}

- (IBAction)fetchMenuItems:(id)sender
{
//    iHotelAppMenuViewController *controller = [[iHotelAppMenuViewController alloc] initWithNibName:@"iHotelAppMenuViewController" bundle:[NSBundle mainBundle]];
    iHotelAppMenuViewController *controller = [[iHotelAppMenuViewController alloc] init];
    
    [self.navigationController pushViewController:controller animated:NO];
}

- (IBAction)simulateRequestError:(id)sender
{
//    [((AppDelegate *)[UIApplication sharedApplication].delegate).engine fetchMenuItemsFromWrongLocationOnSucceeded:^(NSMutableArray *listofModelBaseObjects) {
//        DLog(@"%@", listofModelBaseObjects);
//    } onError:^(NSError *engineError) {
//        [UIAlertView showWithError:engineError];
//    }];
    
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    NSLog(@"appcontroller 的方向");
    return UIInterfaceOrientationPortrait;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
