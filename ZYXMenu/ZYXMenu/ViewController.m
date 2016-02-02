//
//  ViewController.m
//  ZYXMenu
//
//  Created by 7road on 15/10/20.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "ViewController.h"
#import "DropDownView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    DropDownView *dd1 = [[DropDownView alloc] initWithFrame:CGRectMake(200, 200, 140, 100)];
    dd1.textField.placeholder = @"请输入联系方式";
    NSArray* arr=[[NSArray alloc]initWithObjects:@"电话",@"email",@"手机",@"aaa",@"bbb",@"ccc",nil];
    dd1.tableArray = arr;
    [self.view addSubview:dd1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
