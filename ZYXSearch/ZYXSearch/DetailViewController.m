//
//  ViewController.m
//  ZYXSearch
//
//  Created by 7road on 15/10/16.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "DetailViewController.h"
#import "Products.h"

@interface DetailViewController ()

@property (nonatomic, weak) IBOutlet UILabel *yearLabel;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;

@end

@implementation DetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = self.product.title;
    
    self.yearLabel.text = (self.product.yearIntroduced).stringValue;
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    NSString *priceString = [numberFormatter stringFromNumber:self.product.introPrice];
    self.priceLabel.text = priceString;
}

NSString *const ViewControllerProductKey = @"ViewControllerProductKey";

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super encodeRestorableStateWithCoder:coder];
    
    [coder encodeObject:self.product forKey:ViewControllerProductKey];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super decodeRestorableStateWithCoder:coder];
    
    self.product = [coder decodeObjectForKey:ViewControllerProductKey];
}

@end
