//
//  iHotelNavigationController.m
//  ZYiHotel
//
//  Created by 7road on 15/11/25.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "iHotelNavigationController.h"

@interface iHotelNavigationController ()

@end

@implementation iHotelNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    NSLog(@"是否允许旋转");
    return self.topViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    NSLog(@"旋转支持方向");
    return self.topViewController.supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
   
    return self.topViewController.preferredInterfaceOrientationForPresentation;
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
