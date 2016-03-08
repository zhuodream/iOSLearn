//
//  ZYXViewController.m
//  ZYXTestBack
//
//  Created by 7road on 16/3/7.
//  Copyright © 2016年 zhuo. All rights reserved.
//

#import "ZYXViewController.h"
#import "ViewController.h"
@interface ZYXViewController ()

@end

@implementation ZYXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)touchTest:(id)sender
{
    if([self.presentingViewController.presentingViewController isKindOfClass:[ViewController class]])
    {
        NSLog(@"bbbbbb");
    }
    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
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
