//
//  ViewController.m
//  ZYXSDWebImage
//
//  Created by 7road on 16/2/1.
//  Copyright © 2016年 zhuo. All rights reserved.
//

#import "ViewController.h"
#import <SDWebImage/UIButton+WebCache.h>

@interface ViewController ()

@property (nonatomic, strong) UIButton *button;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    self.button.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.button];
    NSURL *url = [NSURL URLWithString:@"http://pica.nipic.com/2007-11-09/200711912453162_2.jpg"];
    [self.button sd_setBackgroundImageWithURL:url forState:UIControlStateNormal];
    self.button.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(200, 200, 200, 200)];
    button.backgroundColor = [UIColor greenColor];
    NSURL *url = [NSURL URLWithString:@"http://pica.nipic.com/2007-11-09/200711912453162_2.jpg"];
    [button sd_setBackgroundImageWithURL:url forState:UIControlStateNormal];
    [self.view addSubview:button];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
