//
//  ViewController.m
//  ZYXSearch
//
//  Created by 7road on 15/10/29.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "ViewController.h"
#import "MainTableViewController.h"

@interface ViewController ()
- (IBAction)touchdown:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    MainTableViewController *mv = (MainTableViewController *)segue.destinationViewController;
    mv.products = [self.products mutableCopy];
}


- (IBAction)touchdown:(id)sender {
     [self performSegueWithIdentifier:@"show" sender:self];
}
@end
