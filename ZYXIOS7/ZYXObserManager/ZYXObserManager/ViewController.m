//
//  ViewController.m
//  ZYXObserManager
//
//  Created by 7road on 15/12/22.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "ViewController.h"
#import "ZYXObserverManager.h"

@protocol MyProtocol <NSObject>

- (void)doSomthing;

@end

@interface MyClass : NSObject <MyProtocol>

@end

@implementation MyClass

- (void)doSomthing
{
    NSLog(@"doSomthing: %@", self);
}

@end

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSSet *observers = [NSSet setWithObjects:[MyClass new], [MyClass new],  nil];
    
    self.observerManager = [[ZYXObserverManager alloc] initWithProtocol:@protocol(MyProtocol) observers:observers];
    [self.observerManager doSomthing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
