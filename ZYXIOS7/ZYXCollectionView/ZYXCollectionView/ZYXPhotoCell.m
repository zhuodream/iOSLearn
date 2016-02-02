//
//  ZYXPhotoCell.m
//  ZYXCollectionView
//
//  Created by 7road on 15/10/9.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "ZYXPhotoCell.h"

@implementation ZYXPhotoCell

- (void)awakeFromNib
{
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
    self.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
    
    
    self.imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.imageView.layer.borderWidth = 5.0f;
    [super awakeFromNib];
}

@end
