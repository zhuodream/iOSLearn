//
//  MenuViewController.h
//  MenuButton
//
//  Created by 7road on 15/9/17.
//  Copyright (c) 2015年 7road. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController

@property (weak,nonatomic) IBOutlet UIButton *shareButton;
@property (weak,nonatomic) IBOutlet UISlider *radiusSlider;
@property (weak,nonatomic) IBOutlet UISlider *bubbleSlider;
@property (weak,nonatomic) IBOutlet UILabel *radiusLabel;
@property (weak,nonatomic) IBOutlet UILabel *bubbleLabel;

- (IBAction)shareTapped:(id)sender;

- (IBAction)radiusValueChanger:(id)sender;

- (IBAction)bubbleRadiusValueChanger:(id)sender;
@end
