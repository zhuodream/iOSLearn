//
//  ZYXCollectionCellCollectionViewCell.m
//  ZYXCoverFlowLayout
//
//  Created by 7road on 15/10/10.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "ZYXCollectionCell.h"

@implementation ZYXCollectionCell

- (void)awakeFromNib
{
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
    self.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
    
    self.photoView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.photoView.layer.borderWidth = 5.0f;
    
    [super awakeFromNib];
}

@end
