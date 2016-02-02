//
//  BNRWebViewController.m
//  Nerdfeed
//
//  Created by 7road on 15/8/3.
//  Copyright (c) 2015年 7road. All rights reserved.
//

#import "BNRWebViewController.h"

@interface BNRWebViewController ()

@end

@implementation BNRWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)loadView
{
    UIWebView *webView=[[UIWebView alloc]init];
    webView.scalesPageToFit=YES;
    self.view=webView;
}

-(void)setURL:(NSURL *)URL
{
    _URL=URL;
    if(URL)
    {
        NSURLRequest *req=[NSURLRequest requestWithURL:_URL];
        [(UIWebView *)self.view loadRequest:req];
    }
}

//实现委托
-(void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
    //如果某个UIBarButtonItem对象没有标题,该对象就不会有任何提示
    barButtonItem.title=@"Courses";
    
    //将传入的UIBarButtonItem对象设置为navigationItem的左侧按钮
    self.navigationItem.leftBarButtonItem=barButtonItem;
}

-(void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    //移除navigationItem的左侧按钮
    //确认该按钮是需要删除的那个（虽然根据现有的代码可以确定不会有错）
    if(barButtonItem==self.navigationItem.leftBarButtonItem)
    {
        self.navigationItem.leftBarButtonItem=nil;
    }
}

@end
