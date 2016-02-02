//
//  ViewController.m
//  ZYXTextKit
//
//  Created by 7road on 15/12/8.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "ViewController.h"
#import "ZYXLayoutView.h"

@interface ViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet ZYXLayoutView *layoutView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
