//
//  BNRPaletteTableViewController.m
//  Colorboard
//
//  Created by 7road on 15/9/9.
//  Copyright (c) 2015年 7road. All rights reserved.
//

#import "BNRPaletteTableViewController.h"
#import "BNRColorDescription.h"
#import "BNRColorViewController.h"

@interface BNRPaletteTableViewController ()

@property (nonatomic) NSMutableArray *colors;


@end

@implementation BNRPaletteTableViewController

- (NSMutableArray *)colors
{
    if(!_colors)
    {
        _colors=[NSMutableArray array];
        
        BNRColorDescription *cd=[[BNRColorDescription alloc] init];
        [_colors addObject:cd];
    }
    
    return _colors;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.colors count];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    BNRColorDescription *color=self.colors[indexPath.row];
    cell.textLabel.text=color.name;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"NewColor"])
    {
        //如果是添加新颜色
        //就创建一个BNRColorDescription对象将其添加到color数组中
        BNRColorDescription *color=[[BNRColorDescription alloc] init];
        [self.colors addObject:color];
        
        //通过UIStoryBoardSegue对象
        //设置BNRColorViewController对象的颜色(colorDescription属性)
        UINavigationController *nc=(UINavigationController *)segue.destinationViewController;
        BNRColorViewController *mvc=(BNRColorViewController *)[nc topViewController];
        mvc.colorDescription=color;
    }
    else if ([segue.identifier isEqualToString:@"ExistingColor"])
    {
        //对于push样式的UIStoryBoardSegue对象，sender是UITableViewSell对象
        NSIndexPath *ip=[self.tableView indexPathForCell:sender];
        BNRColorDescription *color=self.colors[ip.row];
        
        //设置BNRColorViewController对象的颜色
        BNRColorViewController *cvc=(BNRColorViewController *)segue.destinationViewController;
        cvc.colorDescription=color;
        cvc.existingColor=YES;
    }
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
