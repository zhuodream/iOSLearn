//
//  ViewController.m
//  Test
//
//  Created by 7road on 15/10/26.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "ViewController.h"

typedef void(^blk_t)(id obj);

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    blk_t blk;
    {
        id array = [[NSMutableArray alloc] init];
        
        blk = ^(id obj){
            [array addObject:obj];
            NSLog(@"array count = %ld", [array count]);
        };
    }
    
    blk([[NSObject alloc] init]);
    blk([[NSObject alloc] init]);
    blk([[NSObject alloc] init]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
