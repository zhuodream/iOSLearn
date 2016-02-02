//
//  DropDownView.h
//  ZYXMenu
//
//  Created by 7road on 15/10/20.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropDownView : UIView <UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong) UITableView *tv;  //下拉列表
@property (nonatomic, strong) NSArray *tableArray; //下拉列表数据
@property (nonatomic, strong) UITextField *textField;

@end
