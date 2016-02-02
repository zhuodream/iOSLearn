//
//  ViewController.m
//  ZYXUIWebView
//
//  Created by 7road on 15/12/28.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, copy) NSString *htmlStr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *name = @"zhuoyouxin";
    NSDictionary *attr = @{NSForegroundColorAttributeName : [UIColor greenColor]};
    
    
    NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc] initWithString:name attributes:attr];
    [attstr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 4)];
    
    UILabel *myLabel  = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    myLabel.attributedText = attstr;
    [self.view addSubview:myLabel];
    NSLog(@"attstr = %@", attstr);
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    _htmlStr = [self demoFormateWithName:@"First name" value:@"ZHUO"];
    [_webView loadHTMLString:_htmlStr baseURL:baseURL];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"js"];
    NSString *jsString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    NSString *result = [_webView stringByEvaluatingJavaScriptFromString:jsString];

    NSLog(@"result == %@",result);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)demoFormateWithName:(NSString *)name value:(NSString *)value
{
    NSString *html =
    @"<HTML>"
    "<HEAD>"
    "</HEAD>"
    "<BODY>"
    "<H1>%@</H1>"
    "<P>%@</P>"
    "</BODY>"
    "</HTML>";
    
    NSString *content = [NSString stringWithFormat:html, name, value];
    return content;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = [request URL];
    if ([[url scheme] isEqualToString:@"gap"])
    {
        //这里做javascript调objective-c的事情
        NSLog(@"回到oc");
        //做完之后用如下方法调回js
        [webView stringByEvaluatingJavaScriptFromString:@"alert('done')"];
        return NO;
    }
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    NSString *result = [webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
//    NSLog(@"result = %@", result);
    
//       NSString *result = [_webView stringByEvaluatingJavaScriptFromString:@"showAlert()"];
    NSString *result = [_webView stringByEvaluatingJavaScriptFromString:@"loadURL('gap://somthing')"];
    NSLog(@"result == %@",result);
}


@end
