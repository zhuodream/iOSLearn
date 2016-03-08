//
//  DetailViewController.h
//  ZYXCoreDataLearn
//
//  Created by 7road on 16/2/2.
//  Copyright © 2016年 zhuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

