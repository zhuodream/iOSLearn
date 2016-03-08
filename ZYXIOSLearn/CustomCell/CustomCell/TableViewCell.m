//
//  TableViewCell.m
//  CustomCell
//
//  Created by 7road on 16/2/17.
//  Copyright © 2016年 zhuo. All rights reserved.
//

#import "TableViewCell.h"

@interface TableViewCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftSpace;
@property (nonatomic, getter=isDeleting) BOOL deleting;

@end

@implementation TableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (void)setEditing:(BOOL)editing animated:(BOOL)animated
//{
//    [super setEditing:editing animated:animated];
//}

- (void)willTransitionToState:(UITableViewCellStateMask)state
{
    if (state & UITableViewCellStateShowingDeleteConfirmationMask)
    {
        self.deleting = YES;
    }
    else
    {
        self.deleting = NO;
    }
    [super willTransitionToState:state];
}

- (void)beginEditMode
{
    self.leftSpace.constant = self.editing && !self.deleting ? 0: -42;
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    }];
}

@end
