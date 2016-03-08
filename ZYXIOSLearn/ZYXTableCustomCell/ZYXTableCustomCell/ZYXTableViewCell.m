//
//  ZYXTableViewCell.m
//  ZYXTableCustomCell
//
//  Created by 7road on 16/2/16.
//  Copyright © 2016年 zhuo. All rights reserved.
//

#import "ZYXTableViewCell.h"

@interface ZYXTableViewCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftLeadingSpace;
@property (weak, nonatomic) IBOutlet UIButton *editCellButton;
@property (nonatomic, getter=isPseudoEditing) BOOL pseudoEdit;
@property (weak, nonatomic) IBOutlet UIView *mainView;

@end

@implementation ZYXTableViewCell
//- (IBAction)customEditButtonPressed:(id)sender
//{
//    self.buttonSelected = !self.buttonSelected;
//    NSLog(@"选中 = %@", self.buttonSelected ? @"YES" : @"NO");
//    [self.delegate selectCell:self isSelected:self.buttonSelected];
//}

- (void)awakeFromNib {
    // Initialization code
    self.editCellButton.userInteractionEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    NSLog(@"selected = %@", selected ? @"YES" : @"NO");
    self.editCellButton.selected = selected;
    
}

- (IBAction)buttonClicked:(UIButton *)sender
{
    if (sender == self.button1)
    {
        NSLog(@"button1 clicked");
    }
    else if (sender == self.button2)
    {
        NSLog(@"button2 clicked");
    }
    else
    {
        NSLog(@"clicked unknownbutton");
    }
}

//- (void)willTransitionToState:(UITableViewCellStateMask)state
//{
//    if (state & UITableViewCellStateShowingDeleteConfirmationMask)
//    {
//        self.deleting = YES;
//    }
//    else 
//    {
//        self.deleting = NO;
//    }
//    [super willTransitionToState:state];
//}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    if ([self.delegate isPseudoEditing])
    {
        self.pseudoEdit = editing;
        [self beginEditMode];
    }
    else
    {
        [super setEditing:editing animated:animated];
    }
}

// Animate view to show/hide custom edit control/button
- (void)beginEditMode {
    self.leftLeadingSpace.constant = self.isPseudoEditing ? 0 : -42;
    
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    }];
}

@end
