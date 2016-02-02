//
//  HeaderView.h
//  ZYXQQList
//
//  Created by 7road on 15/10/15.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYXGroupModel.h"

@class HeaderView;
@protocol HeaderViewDelegate <NSObject>

@optional
- (void)clickView:(HeaderView *)view;

@end

@interface HeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) UIButton *arrowBtn;

@property (nonatomic, weak) id<HeaderViewDelegate> delegate;

@property (nonatomic, strong) ZYXGroupModel *groupModel;

+ (instancetype)headerView:(UITableView *)tableView;

@end
