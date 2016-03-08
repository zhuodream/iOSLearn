//
//  ViewController.m
//  buttontest
//
//  Created by 7road on 15/12/14.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSString *_name;
}

@property (nonatomic, strong) dispatch_queue_t syncQueue;
//@property (nonatomic, copy) NSString *name;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   // _syncQueue = dispatch_queue_create("com.zhuo", DISPATCH_QUEUE_SERIAL);
    // Do any additional setup after loading the view, typically from a nib.
//    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20, 50, 100, 100)];
//    button.backgroundColor = [UIColor greenColor];
//    [button setBackgroundImage:[self imageByColor:[UIColor blueColor] size:button.frame.size] forState:UIControlStateNormal];
//    [button setBackgroundImage:[self imageByColor:[UIColor redColor] size:button.frame.size] forState:UIControlStateHighlighted];
//    [self.view addSubview:button];
    self.tableView.delaysContentTouches = NO;
//    NSString *str = @"Myname";
//    NSString *copstr = [str copy];
//    NSLog(@"str = %@", str);
//    str = @"name";
//    NSLog(@"copy str = %@", copstr);
//
//    NSMutableString *myString = [[NSMutableString alloc] initWithString:@"mine"];
//    NSMutableArray *array = [NSMutableArray array];
//    [array addObject:myString];
//    NSArray *array = [NSArray arrayWithObjects:myString, nil];
//    NSMutableArray *myArray = [array mutableCopy];
//    NSLog(@"number = %@", myString);
//    //number = @6;
//    [myString replaceCharactersInRange:NSMakeRange(0, 1) withString:@"a"];
//    NSLog(@"arrayObject = %@", array[0]);
//    NSLog(@"myArray Object = %@", myArray[0]);
//    
//    Class newclass = objc_allocateClassPair([UIView class], "ZhuoCustonView", 0);
//    
//    //为该类增加一个report方法
//    class_addMethod(newclass, @selector(report), (IMP)ReportFunction, "v@:");
//    //注册该类
//    objc_registerClassPair(newclass);
//    
//    //创建一个实例
//    id instanceClassPair = [[newclass alloc] init];
//    //调用report方法
//    [instanceClassPair performSelector:@selector(report)];
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        self.name = @"aaaaaaaaaaa";
//        NSLog(@"first queue = %@", self.name);
//     
//    });
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSString *myname = self.name;
//        NSLog(@"线程1 == %@", myname);
//       // dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            NSString *nameaa = self.name;
//            NSLog(@"线程11 =＝ %@", nameaa);
//        //});
//    });
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        self.name = @"bbbbbbbbbbb";
//        NSLog(@"second  ====== %@", self.name);
//    });
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSString *name = self.name;
//        NSLog(@"get second name = %@", name);
//    });
//    NSLog(@"aaaaaaa");
//    dispatch_sync(dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSLog(@"bbbbbbb");
//        NSLog(@"thread === %@", [NSThread currentThread]);
//    });
//    NSLog(@"main thread = %@", [NSThread currentThread]);
//    NSLog(@"cccccccc");
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSLog(@"NSString = %@", str);
   // NSString *timeNow = @"2999-01-01 00:00:00.0";
    if ([str compare:@"2999-01-01 00:00:00.0" options:NSDiacriticInsensitiveSearch] == NSOrderedAscending)
    {
        NSLog(@"true= =====");
    }
}

- (NSString *)name
{
    __block NSString *localName;
    dispatch_sync(_syncQueue, ^{
         NSLog(@"获取");
        localName = _name;
    });
    return localName;
}

- (void)setName:(NSString *)name
{
    dispatch_async(_syncQueue, ^{
        NSLog(@"设置");
        _name = name;
    });
}


void ReportFunction(id self, SEL _cmd)
{
    NSLog(@"This object is %p", self);
    NSLog(@"Class is %@, and super is %@.", [self class], [self superclass]);
    
    Class currentClass = [self class];
    for (int i = 1; i < 5; i++)
    {
        NSLog(@"Folllowing the isa pointer %d times gives %p", i, currentClass);
        currentClass = object_getClass(currentClass);
    }
    
    NSLog(@"NSObject's class is %p", [NSObject class]);
    NSLog(@"NSObject's meta class is %p", object_getClass([NSObject class]));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] init];
    //UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 50, 50);
    [button setBackgroundImage:[self imageByColor:[UIColor redColor] size:button.frame.size] forState:UIControlStateNormal];
    [button setBackgroundImage:[self imageByColor:[UIColor greenColor] size:button.frame.size] forState:UIControlStateHighlighted];
    [footerView addSubview:button];
    button.backgroundColor = [UIColor redColor];
    footerView.userInteractionEnabled = YES;
    
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 75;
}

- (UIImage *)imageByColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

@end
