//
//  ZYXTableViewController.m
//  ZYXTableCustomCell
//
//  Created by 7road on 16/2/16.
//  Copyright © 2016年 zhuo. All rights reserved.
//

#import "ZYXTableViewController.h"
#import "ZYXTableViewCell.h"

@interface ZYXTableViewController ()<ZYXTableViewCellDelegete>

@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, getter=isPseudoEditing) BOOL pseudoEdit;

@end

@implementation ZYXTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.navigationController.title = @"CustomCell";
    _array = [NSMutableArray array];
    NSInteger numberOfItems = 5;
    for (NSInteger i = 1; i <= numberOfItems; ++i)
    {
        NSString *item = [NSString stringWithFormat:@"Item #%ld", i];
        [_array addObject:item];
    }
    self.tableView.delaysContentTouches = NO;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    self.pseudoEdit = YES;
    [super setEditing:editing animated:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZYXTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell)
    {
        cell = [[ZYXTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.delegate = self;
    NSString *item = _array[indexPath.row];
    cell.text.text = item;
    cell.button1.hidden = YES;
    cell.button2.hidden = YES;
//#ifdef DEBUG
//    NSLog(@"Cell recursive description:\n\n%@\n\n", [cell performSelector:@selector(recursiveDescription)]);
//#endif
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击cell");
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
//#ifdef DEBUG
//        NSLog(@"Cell recursive description:\n\n%@\n\n", [[tableView cellForRowAtIndexPath:indexPath] performSelector:@selector(recursiveDescription)]);
//#endif
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}


#pragma mark - ZYXTableviewCellDelegate
- (void)selectCell:(ZYXTableViewCell *)cell isSelected:(BOOL)isSelected
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    UITableView *tableView = self.tableView;
    if (isSelected) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        
        // Above method will not call the below delegate methods
        if ([tableView.delegate respondsToSelector:@selector(tableView:willSelectRowAtIndexPath:)]) {
            [tableView.delegate tableView:tableView willSelectRowAtIndexPath:indexPath];
        }
        if ([tableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
            [tableView.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
        }
    } else {
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        
        // Above method will not call the below delegate methods
        if ([tableView.delegate respondsToSelector:@selector(tableView:willDeselectRowAtIndexPath:)]) {
            [tableView.delegate tableView:tableView willDeselectRowAtIndexPath:indexPath];
        }
        if ([tableView.delegate respondsToSelector:@selector(tableView:didDeselectRowAtIndexPath:)]) {
            [tableView.delegate tableView:tableView didDeselectRowAtIndexPath:indexPath];
        }
    }

}

@end
