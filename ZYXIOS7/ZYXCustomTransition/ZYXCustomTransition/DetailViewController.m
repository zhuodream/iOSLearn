//
//  DetailViewController.m
//  ZYXCustomTransition
//
//  Created by 7road on 15/12/7.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

- (void)configureView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureView];
    NSLog(@"self detail = %@", self);
}

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem)
    {
        _detailItem = newDetailItem;
        [self configureView];
    }
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSLog(@"self.view.superView = %@", self.view.superview);
}
- (IBAction)closeButtonTapper:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)configureView
{
    if (self.detailItem)
    {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}




@end
