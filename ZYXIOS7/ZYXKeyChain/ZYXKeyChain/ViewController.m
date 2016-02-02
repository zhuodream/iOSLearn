//
//  ViewController.m
//  ZYXKeyChain
//
//  Created by 7road on 16/1/11.
//  Copyright © 2016年 zhuo. All rights reserved.
//

#import "ViewController.h"
#import "ZYXKeyChain.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSError *error = nil;
    [ZYXKeyChain storeUserName:@"zhuoyouxiaa" andPassword:@"123456" forServiceName:@"Myaccount" updateExisting:YES error:&error];
    NSLog(@"error = %@", error);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSError *error = nil;
    NSString *password = [ZYXKeyChain getPasswordForUserName:@"zhuoyouxiaa" andServiceName:@"Myaccount" error:nil];
     NSLog(@"error = %@", error);
    NSLog(@"pass = %@", password);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
