//
//  DropDownView.m
//  ZYXMenu
//
//  Created by 7road on 15/10/20.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "DropDownView.h"

@interface DropDownView ()
{
    BOOL showList;
    CGFloat tableHeight;
    CGFloat frameHeight;
}

@end

@implementation DropDownView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (frame.size.height < 200)
    {
        frameHeight = 200;
    }
    else
    {
        frameHeight = frame.size.height;
    }
    
    tableHeight = frameHeight - 30;
    frame.size.height = 30.0f;
    
    self = [super initWithFrame:frame];
    
    if (self)
    {
        showList = NO;
        
        _tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
        _tv.delegate = self;
        _tv.dataSource = self;
        _tv.backgroundColor = [UIColor grayColor];
        _tv.separatorColor = [UIColor lightGrayColor];
        _tv.hidden = YES;
        
        [self addSubview:_tv];
        
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
        _textField.borderStyle=UITextBorderStyleRoundedRect;//设置文本框的边框风格
        [_textField addTarget:self action:@selector(dropdown) forControlEvents:UIControlEventAllTouchEvents];
        [self addSubview:_textField];
        
    }
    return self;
}

- (void)dropdown{
    [self.textField resignFirstResponder];
    if (showList) {//如果下拉框已显示，什么都不做
        return;
    }else {//如果下拉框尚未显示，则进行显示
        
        CGRect sf = self.frame;
        sf.size.height = frameHeight;
        
        //把dropdownList放到前面，防止下拉框被别的控件遮住
        [self.superview bringSubviewToFront:self];
        self.tv.hidden = NO;
        showList = YES;//显示下拉框
        
        CGRect frame = self.tv.frame;
        frame.size.height = 0;
        self.tv.frame = frame;
        frame.size.height = tableHeight;
        [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        self.frame = sf;
        self.tv.frame = frame;
        [UIView commitAnimations];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [self.tableArray objectAtIndex:[indexPath row]];
    cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.textField.text = [self.tableArray objectAtIndex:[indexPath row]];
    showList = NO;
    self.tv.hidden = YES;
    
    CGRect sf = self.frame;
    sf.size.height = 30;
    self.frame = sf;
    CGRect frame = self.tv.frame;
    frame.size.height = 0;
    self.tv.frame = frame;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
