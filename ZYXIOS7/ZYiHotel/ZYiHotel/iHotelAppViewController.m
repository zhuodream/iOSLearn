//
//  iHotelAppViewController.m
//  ZYiHotel
//
//  Created by 7road on 15/11/23.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "iHotelAppViewController.h"
#import "RESTfulOperation.h"
#import "RESTfulEngine.h"
#import "AppDelegate.h"
#import "iHotelAppMenuViewController.h"

@interface iHotelAppViewController ()

@property (nonatomic) RESTfulOperation *menuRequest;

@end

@implementation iHotelAppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"iHotel App Demo";
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"appviewcontroller willappear");
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)loginButtonTapped:(id)sender
{
    [((AppDelegate *)[UIApplication sharedApplication].delegate).engine loginWithName:@"mugunth" password:@"abracadabra" onSucceeded:^{
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Success", @"") message:NSLocalizedString(@"Login successful", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Dismiss", @"") otherButtonTitles:nil] show];
    } onError:^(NSError *engineError) {
        [UIAlertView showWithError:engineError];
    }];
}

- (IBAction)fetchMenuItems:(id)sender
{
    iHotelAppMenuViewController *controller = [[iHotelAppMenuViewController alloc] initWithNibName:@"iHotelAppMenuViewController" bundle:[NSBundle mainBundle]];

//    iHotelAppMenuViewController *controller = [[iHotelAppMenuViewController alloc] init];
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)simulateRequestError:(id)sender
{
    [((AppDelegate *)[UIApplication sharedApplication].delegate).engine fetchMenuItemsFromWrongLocationOnSucceeded:^(NSMutableArray *listofModelBaseObjects) {
        DLog(@"%@", listofModelBaseObjects);
    } onError:^(NSError *engineError) {
        [UIAlertView showWithError:engineError];
    }];
    
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//   // NSLog(@"app 的方向");
//    return UIInterfaceOrientationPortrait;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
