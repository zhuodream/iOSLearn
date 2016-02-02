//
//  BNRColorViewController.m
//  Colorboard
//
//  Created by 7road on 15/9/9.
//  Copyright (c) 2015年 7road. All rights reserved.
//

#import "BNRColorViewController.h"

@interface BNRColorViewController ()

@property (nonatomic,weak) IBOutlet UITextField *textField;

@property (nonatomic,weak) IBOutlet UISlider *redSlider;
@property (nonatomic,weak) IBOutlet UISlider *greenSlider;
@property (nonatomic,weak) IBOutlet UISlider *blueSlider;

@end

@implementation BNRColorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIColor * color=self.colorDescription.color;
    
    //从UIColor对象中提取RGB颜色分量
    CGFloat red,green,blue;
    [color getRed:&red green:&green blue:&blue alpha:nil];
    
    //初始化UISlider对象的滑块值
    self.redSlider.value=red;
    self.greenSlider.value=green;
    self.blueSlider.value=blue;
    
    //初始化view的北京颜色和颜色名称
    self.view.backgroundColor=color;
    self.textField.text=self.colorDescription.name;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismiss:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)changeColor:(id)sender
{
    float red=self.redSlider.value;
    float green=self.greenSlider.value;
    float blue=self.blueSlider.value;
    UIColor *newColor=[UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    
    self.view.backgroundColor=newColor;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //如果颜色已经存在,就移除Done按钮
    if(self.existingColor)
    {
        self.navigationItem.rightBarButtonItem=nil;
    }
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.colorDescription.name=self.textField.text;
    self.colorDescription.color=self.view.backgroundColor;
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
