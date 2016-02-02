//
//  ReminderViewController.m
//  HypneNerd
//
//  Created by 7road on 15/7/23.
//  Copyright (c) 2015年 7road. All rights reserved.
//

#import "ReminderViewController.h"

//添加类扩展
@interface ReminderViewController ()
@property (nonatomic,weak) IBOutlet UIDatePicker *datePiker;

@end

@implementation ReminderViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self)
    {
        //获取tabBarItem属性指向的UITabBarItem对象
        UITabBarItem *tbi=self.tabBarItem;
        
        
        //设置标签项标题
        tbi.title=@"Reminder";
        //从图像文件创建一个UIImage对象
        UIImage *i=[UIImage imageNamed:@"Time.png"];
        
        tbi.image=i;
    }
    return self;
}



-(IBAction)addReminder:(id)sender
{
    NSDate *date=self.datePiker.date;
    NSLog(@"Setting a reminder for %@",date);
    
    //本地通知
    UILocalNotification *note=[[UILocalNotification alloc] init];
    note.alertBody=@"Hypnotize me!";
    note.fireDate=date;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:note];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"ReminderViewController loaded its view.");
}

-(void)viewWillAppear:(BOOL)animated
{
    //animated是否显示过渡动画
    [super viewWillAppear:animated];
    //设置可供选择的最小时间
    self.datePiker.minimumDate=[NSDate dateWithTimeIntervalSinceNow:60];
}

@end
