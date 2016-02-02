//
//  ViewController.m
//  ZYXCustomController
//
//  Created by 7road on 15/12/7.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"
#import "PercentDrivenAnimator.h"

@interface ViewController ()
{
    NSMutableArray *_objects;
}


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"Will");
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"Did");
    [super viewDidAppear:animated];
}

//UIViewControllerAnimatedTransition
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 1.0f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *src = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *dest = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGPoint centerPoint = src.view.center;
    dest.view.frame = CGRectMake(centerPoint.x, centerPoint.y, 10, 10);
    [[src.view superview] addSubview:dest.view];
    [UIView animateWithDuration:1.0 animations:^{
        dest.view.frame = CGRectMake(10, 10, 300, src.view.frame.size.height - 20);
        dest.view.center = centerPoint;
    } completion:^(BOOL finished) {
        //[dest.view removeFromSuperview];
        [transitionContext completeTransition:YES];
    }];
}



- (void)insertNewObject:(id)sender
{
    if (!_objects)
    {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

//UIViewControllerTransitionDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self;
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSDate *object = _objects[indexPath.row];
    cell.textLabel.text = [object description];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detailViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DetailViewController"];
    
    detailViewController.detailItem = _objects[indexPath.row];
    detailViewController.transitioningDelegate = self;
    [self.navigationController presentViewController:detailViewController animated:YES completion:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        NSLog(@"插入");
    }
    
}



@end
