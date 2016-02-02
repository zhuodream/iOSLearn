//
//  ViewController.m
//  ZYXRestoreState
//
//  Created by 7road on 15/11/18.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "ViewController.h"

//static NSString *textstr = @"";

@interface ViewController () <UIViewControllerRestoration>
//@property (weak, nonatomic) IBOutlet UITextField *text;

@end

@implementation ViewController

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.restorationIdentifier = @"ViewController";
        self.restorationClass = [self class];
        
        
        self.text = [[UITextField alloc] initWithFrame:CGRectMake(100, 100, 200, 100)];
            
        self.text.borderStyle = UITextBorderStyleLine;
        
        self.text.restorationIdentifier = @"textRestore";
        NSLog(@"chushihua");

    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.text];
    // Do any additional setup after loading the view, typically from a nib.
    //self.text.text = textstr;
    NSLog(@"text ===== %@", self.text.text);
  
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
}


- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    NSString *key = @"text";
    NSLog(@"编码固化的数据");
    [coder encodeObject:self.text.text forKey:key];
    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    NSLog(@"解码固化的数据");
    NSString *textstr = [coder decodeObjectForKey:@"text"];
    
    NSLog(@"textstr = %@", textstr);
    self.text.text = textstr;
    NSLog(@"文本框的文字 ＝ %@", self.text.text);
    
    [super decodeRestorableStateWithCoder:coder];
}

+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    NSLog(@"进入恢复类方法");
    ViewController *vc = [[self alloc] init];
   
    
    NSLog(@"Application = %@", [UIApplication sharedApplication]);
    
    [UIApplication sharedApplication].delegate.window.rootViewController = vc;
   
    return vc;
}


@end
