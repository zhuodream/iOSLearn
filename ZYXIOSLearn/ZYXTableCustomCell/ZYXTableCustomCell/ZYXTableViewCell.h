//
//  ZYXTableViewCell.h
//  ZYXTableCustomCell
//
//  Created by 7road on 16/2/16.
//  Copyright © 2016年 zhuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZYXTableViewCell;

@protocol ZYXTableViewCellDelegete

@optional
@property (nonatomic, readonly, getter=isPseudoEditing) BOOL pseudoEdit;
- (void)selectCell:(ZYXTableViewCell *)cell isSelected:(BOOL)isSelected;

@end

@interface ZYXTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *text;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (nonatomic, strong) NSString *itemText;
- (IBAction)buttonClicked:(UIButton *)sender;
@property (nonatomic, weak) id<ZYXTableViewCellDelegete> delegate;
@end
