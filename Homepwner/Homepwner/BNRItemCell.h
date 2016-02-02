//
//  BNRItemCell.h
//  Homepwner
//
//  Created by 7road on 15/7/31.
//  Copyright (c) 2015年 7road. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNRItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

//Block对象是在栈中创建的，创建该对象的方法返回时，与方法内部的其他局部变量相同，新创建的Block对象也会被立即释放,因此需要发送copy消息
@property (nonatomic,copy) void(^actionBlock)(void);

@end
