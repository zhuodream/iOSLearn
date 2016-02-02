//
//  ViewController.m
//  ZYXCurvyText
//
//  Created by 7road on 15/12/11.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "ViewController.h"
#import "ZYXCurvyTextView.h"
#import <Crashlytics/Crashlytics.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(200, 200, 100, 100);
    [button setTitle:@"Crash" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(crashButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    ;

    
    ZYXCurvyTextView *curvyTextView = [[ZYXCurvyTextView alloc] initWithFrame:self.view.bounds];
    
    [curvyTextView addSubview:button];
    [self.view addSubview:curvyTextView];
    
    NSString *string = @"You can display text along a curve, with bold, color, and big text.";
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.0]}];
    
    [attrString addAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:16]} range:[string rangeOfString:@"bold"]];
    
    [attrString addAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]} range:[string rangeOfString:@"color"]];
    
    [attrString addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:32]} range:[string rangeOfString:@"big text"]];
    
    curvyTextView.attributedString = attrString;
}

- (void)crashButtonTapped:(id)sender {
    [[Crashlytics sharedInstance] crash];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
