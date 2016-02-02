//
//  BaseTableTableViewController.h
//  ZYXSearch
//
//  Created by 7road on 15/10/19.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Products;

extern NSString * const kCellIdentifier;

@interface BaseTableTableViewController : UITableViewController

- (void)configureCell:(UITableViewCell *)cell forProduct:(Products *)product;

@end
