//
//  ViewController.m
//  ZYXSegement
//
//  Created by 7road on 15/10/12.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UISegmentedControl * titie = [[UISegmentedControl alloc] initWithItems:@[@"aa",@"bb"]];
    titie.frame = CGRectMake(0, 0, 100, 20);
   [titie setTintColor:[UIColor redColor]];
    //UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//    view.backgroundColor = [UIColor redColor];
    self.navigationItem.titleView = titie;
//    self.navigationController.view = view;
    self.navigationController.navigationBar.backgroundColor = [UIColor greenColor];
    NSLog(@"view = %@", self.navigationItem.titleView);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
