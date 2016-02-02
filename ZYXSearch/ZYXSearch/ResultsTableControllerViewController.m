//
//  ResultsTableControllerViewController.m
//  ZYXSearch
//
//  Created by 7road on 15/10/19.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "ResultsTableControllerViewController.h"
#import "Products.h"

@interface ResultsTableControllerViewController ()

@end

@implementation ResultsTableControllerViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.filteredProducts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    Products *product = self.filteredProducts[indexPath.row];
    [self configureCell:cell forProduct:product];
    
    return cell;
}

@end
