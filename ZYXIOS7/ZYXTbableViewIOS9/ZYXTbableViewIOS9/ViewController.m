//
//  ViewController.m
//  ZYXTbableViewIOS9
//
//  Created by 7road on 16/1/27.
//  Copyright © 2016年 zhuo. All rights reserved.
//

#import "ViewController.h"
#import "ZYXCell.h"
#import "TestViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //self.tableView.backgroundColor = [UIColor blueColor];
    self.tableView.cellLayoutMarginsFollowReadableWidth = NO;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYXCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZYXCell"];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZYXCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZYXCell"];
    cell.nameLabel.text = @"zyx";
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.separatorInset = UIEdgeInsetsZero;
    [cell setPreservesSuperviewLayoutMargins:NO];
    cell.layoutMargins = UIEdgeInsetsZero;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        NSLog(@"aaaaaaa");
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        TestViewController *viewCtr = [storyboard instantiateViewControllerWithIdentifier:@"ZHUO"];
  
//        UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:viewCtr];或者下面这个方法，不过设置root更好理解
        UINavigationController *controller = [[UINavigationController alloc] init];
        [controller pushViewController:viewCtr animated:YES];
        NSLog(@"TestViewControlle = %@", viewCtr);
        NSLog(@"nav = %@", controller);
//     [self.navigationController pushViewController:controller animated:YES];nav不允许push nav所以只能使用present
        [self presentViewController:controller animated:YES completion:nil];
    }
    //最终结构其实是window.root->nav-(root)>viewcontroller-(present)>nav-(root)>testviewcontroller
}

@end
