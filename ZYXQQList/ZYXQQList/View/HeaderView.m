//
//  HeaderView.m
//  ZYXQQList
//
//  Created by 7road on 15/10/15.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "HeaderView.h"
#import "ZYXGroupModel.h"

@implementation HeaderView
{
    UILabel *_label;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)headerView:(UITableView *)tableView
{
    static NSString *identifier = @"header";
    HeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!header)
    {
        NSLog(@"不重用");
        header = [[HeaderView alloc] initWithReuseIdentifier:identifier];
    }
    else
    {
        NSLog(@"重用");
    }
//    HeaderView *header = [[HeaderView alloc] initWithReuseIdentifier:identifier];
    return header;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"header_bg"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"header_bg_highlighted"] forState:UIControlStateHighlighted];
        [button setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        button.imageView.contentMode = UIViewContentModeCenter;
        [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
        button.imageView.clipsToBounds = NO;
        
        _arrowBtn = button;
        [self addSubview:_arrowBtn];
        
        //创建label，显示在线人数
        UILabel *labelRight = [[UILabel alloc] init];
        labelRight.textAlignment = NSTextAlignmentCenter;
        _label = labelRight;
        [self addSubview:_label];
    }
    
    return self;
}

#pragma mark - buttonAction
- (void)buttonAction
{
    self.groupModel.isOpen = !self.groupModel.isOpen;
    if ([self.delegate respondsToSelector:@selector(clickView:)])
    {
        [self.delegate clickView:self];
    }
}


//- (void)didMoveToSuperview
//{
//    NSLog(@"didMoveTosuperView");
//    _arrowBtn.imageView.transform = self.groupModel.isOpen ? CGAffineTransformMakeRotation(M_PI_2) : CGAffineTransformMakeRotation(0);
//}

//布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _arrowBtn.frame = self.bounds;
    _label.frame = CGRectMake(self.frame.size.width - 70, 0, 60, self.frame.size.height);
}

//赋值
- (void)setGroupModel:(ZYXGroupModel *)groupModel
{
    _groupModel = groupModel;
    [_arrowBtn setTitle:_groupModel.name forState:UIControlStateNormal];
    _label.text = [NSString stringWithFormat:@"%@/%lu", _groupModel.online, _groupModel.friends.count];
    NSLog(@"isopen = %s", _groupModel.isOpen ? "YES" : "NO");
    _arrowBtn.imageView.transform = self.groupModel.isOpen ? CGAffineTransformMakeRotation(M_PI_2) : CGAffineTransformMakeRotation(0);
}



@end
