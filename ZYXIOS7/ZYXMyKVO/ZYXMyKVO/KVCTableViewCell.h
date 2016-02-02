//
//  KVCTableViewCell.h
//  ZYXMyKVO
//
//  Created by 7road on 15/12/21.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KVCTableViewCell : UITableViewCell

- (id)initWithReuseIdentifier:(NSString *)identifier;
@property (nonatomic, readwrite, strong) id object;
@property (nonatomic, readwrite, copy) NSString *property;

@end
