//
//  BNRItemCell.m
//  Homepwner
//
//  Created by 7road on 15/7/31.
//  Copyright (c) 2015年 7road. All rights reserved.
//

#import "BNRItemCell.h"

@interface BNRItemCell ()

@property (nonatomic,weak) IBOutlet NSLayoutConstraint *imageViewHeightContraint;
//@property (nonatomic,weak) IBOutlet NSLayoutConstraint *imageViewWidthContraint;

@end

@implementation BNRItemCell


-(void)updateInterfaceForDynamicTypeSize
{
    UIFont *font=[UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.nameLabel.font=font;
    self.serialNumberLabel.font=font;
    self.valueLabel.font=font;
    
    static NSDictionary *imageSizeDictionary;
    
    if(!imageSizeDictionary)
    {
        imageSizeDictionary=@{
                              UIContentSizeCategoryExtraSmall:@40,
                              UIContentSizeCategorySmall:@40,
                              UIContentSizeCategoryMedium:@40,
                              UIContentSizeCategoryLarge:@40,
                              UIContentSizeCategoryExtraLarge:@45,
                              UIContentSizeCategoryExtraExtraLarge:@55,
                              UIContentSizeCategoryExtraExtraExtraLarge:@65
                              };
    }
    
    NSString *userSize=[[UIApplication sharedApplication] preferredContentSizeCategory];
    
    NSNumber *imageSize=imageSizeDictionary[userSize];
    self.imageViewHeightContraint.constant=imageSize.floatValue;
//    self.imageViewWidthContraint.constant=imageSize.floatValue;
//    NSLog(@"%f",imageSize.floatValue);
}

- (void)awakeFromNib {
    // Initialization code
    [self updateInterfaceForDynamicTypeSize];
    
    NSNotificationCenter *nc=[NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(updateInterfaceForDynamicTypeSize) name:UIContentSizeCategoryDidChangeNotification object:nil];
    
    NSLayoutConstraint *constraint=[NSLayoutConstraint constraintWithItem:self.thumbnailView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.thumbnailView attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
    
    [self.thumbnailView addConstraint:constraint];
}

-(void)dealloc
{
    NSNotificationCenter *nc=[NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(IBAction)showImage:(id)sender
{
    //调用Block对象之前，要检查Block对象是否存在
    if(self.actionBlock)
    {
        self.actionBlock();
    }
}

@end
