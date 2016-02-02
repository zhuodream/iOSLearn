//
//  BNRImageViewController.m
//  Homepwner
//
//  Created by 7road on 15/8/1.
//  Copyright (c) 2015年 7road. All rights reserved.
//

#import "BNRImageViewController.h"

@interface BNRImageViewController ()

@end

@implementation BNRImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImageView *imageView=[[UIImageView alloc]init];
    imageView.contentMode=UIViewContentModeScaleAspectFill;
    
    //不希望超过frame的区域显示在屏幕上要设置
    //imageView.clipsToBounds  = YES;
    
    self.view=imageView;
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //必须将view转换为UIImageView对象，以便向其发送setImage:消息
    UIImageView *imageView=(UIImageView *)self.view;
    
    imageView.image=self.image;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
