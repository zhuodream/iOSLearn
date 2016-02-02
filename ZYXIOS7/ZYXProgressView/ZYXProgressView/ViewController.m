//
//  ViewController.m
//  ZYXProgressView
//
//  Created by 7road on 16/1/21.
//  Copyright © 2016年 zhuo. All rights reserved.
//

#import "ViewController.h"
#import "ZYXProgressView.h"

@interface ViewController ()

@property (nonatomic, strong) ZYXProgressView *progressView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    // Do any additional setup after loading the view, typically from a nib.
    _progressView = [[ZYXProgressView alloc] initWithFrame:self.view.bounds];
    
    [self.view addSubview:_progressView];
    [_progressView show];
   
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    for (int i = 0; i < 50; ++i)
    {
        _progressView.progress += i/10000.0;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
