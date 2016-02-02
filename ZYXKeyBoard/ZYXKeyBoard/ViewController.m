//
//  ViewController.m
//  ZYXKeyBoard
//
//  Created by 7road on 15/10/22.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITextFieldDelegate>
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillshow:) name:UIKeyboardDidShowNotification object:nil];
}


//- (void)keyboardWillshow:(NSNotification *)notification
//{
//    NSDictionary *info = [notification userInfo];
//    
//    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
//    CGRect beginKeyboardRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
//    CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    NSLog(@"begin orign x= %f, y = %f, size width = %f, height = %f", beginKeyboardRect.origin.x, beginKeyboardRect.origin.y, beginKeyboardRect.size.width, beginKeyboardRect.size.height);
//    
//    NSLog(@"end orign x= %f, y = %f, size width = %f, height = %f", endKeyboardRect.origin.x, endKeyboardRect.origin.y, endKeyboardRect.size.width, endKeyboardRect.size.height);
//    
//    CGFloat yOffset = endKeyboardRect.origin.y - beginKeyboardRect.origin.y;
//    
//    CGRect inputFieldRect = self.textField.frame;
//    inputFieldRect.origin.y += yOffset;
//    NSLog(@"field orign x= %f, y = %f, size width = %f, height = %f", inputFieldRect.origin.x, inputFieldRect.origin.y, inputFieldRect.size.width, inputFieldRect.size.height);
//    
//    [UIView animateWithDuration:duration animations:^{
//        self.textField.frame = inputFieldRect;
//    }];
//   
//}

- (void)keyboardWillshow:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSLog(@"duration = %f", duration);
    CGRect beginKeyboardRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat yOffset =beginKeyboardRect.origin.y - endKeyboardRect.origin.y;
    NSLog(@"yset = %f", yOffset);
    CGRect frame = self.view.frame;
    frame.size = CGSizeMake(frame.size.width, frame.size.height - yOffset);

    CGRect inputFieldRect = self.textField.frame;
    inputFieldRect.origin.y -= yOffset;

    [UIView animateWithDuration:duration animations:^{
                self.textField.frame = inputFieldRect;
        }];
    NSLog(@"field orign x= %f, y = %f, size width = %f, height = %f", self.textField.frame.origin.x, self.textField.frame.origin.y, self.textField.frame.size.width, self.textField.frame.size.height);
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.textField resignFirstResponder];
    NSLog(@"field orign x= %f, y = %f, size width = %f, height = %f", self.textField.frame.origin.x, self.textField.frame.origin.y, self.textField.frame.size.width, self.textField.frame.size.height);
}



-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSLog(@"aaaa");
    NSLog(@"field orign x= %f, y = %f, size width = %f, height = %f", self.textField.frame.origin.x, self.textField.frame.origin.y, self.textField.frame.size.width, self.textField.frame.size.height);
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"field orign x= %f, y = %f, size width = %f, height = %f", self.textField.frame.origin.x, self.textField.frame.origin.y, self.textField.frame.size.width, self.textField.frame.size.height);
    return YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
