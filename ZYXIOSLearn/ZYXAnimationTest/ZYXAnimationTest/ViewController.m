//
//  ViewController.m
//  ZYXAnimationTest
//
//  Created by 7road on 16/2/25.
//  Copyright © 2016年 zhuo. All rights reserved.
//

#import "ViewController.h"
#import "ZYXCircleAnimateView.h"

@interface ViewController ()

@property (nonatomic, strong) ZYXCircleAnimateView *progressView;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"self.view.bounds = %@", NSStringFromCGRect(self.view.frame));
    self.imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.imageView.image = [UIImage imageNamed:@"11"];
    [self.view addSubview:self.imageView];
    self.progressView = [[ZYXCircleAnimateView alloc] initWithFrame:self.view.bounds];
    [self.imageView addSubview:self.progressView];
    
    NSLog(@"class = %@", [self class]);
    NSLog(@"super = %@", [super class]);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.progressView startAnimation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
