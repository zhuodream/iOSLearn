//
//  DetailViewController.h
//  ZYXIOS7
//
//  Created by 7road on 15/10/9.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

