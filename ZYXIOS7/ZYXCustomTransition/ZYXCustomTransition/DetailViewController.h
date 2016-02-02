//
//  DetailViewController.h
//  ZYXCustomTransition
//
//  Created by 7road on 15/12/7.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (nonatomic, strong) id detailItem;

@property (nonatomic, weak) IBOutlet UILabel *detailDescriptionLabel;

@end
