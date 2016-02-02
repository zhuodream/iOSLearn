//
//  ZYXCustomSegue.m
//  ZYXIOS7
//
//  Created by 7road on 15/10/9.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "ZYXCustomSegue.h"

@implementation ZYXCustomSegue

- (void)perform
{
    UIViewController *src = (UIViewController *)self.sourceViewController;
    UIViewController *dest = (UIViewController *)self.destinationViewController;
    
    CGRect f = src.view.frame;
    NSLog(@"f.origin.x = %f, f.origin.y = %f, f.size.height = %f, f.size.width = %f", f.origin.x, f.origin.y, f.size.height, f.size.width);
    CGRect originalSourceRect = src.view.frame;
    f.origin.y = f.size.height;
    
    [UIView animateWithDuration:0.3 animations:^{
        src.view.frame = f;
    } completion:^(BOOL finished) {
        src.view.alpha = 0;
        dest.view.frame = f;
        dest.view.alpha = 0.0f;
        [[src.view superview] addSubview:dest.view];
        [UIView animateWithDuration:0.3 animations:^{
            dest.view.frame = originalSourceRect;
            dest.view.alpha = 1.0f;
        } completion:^(BOOL finished) {
            [dest.view removeFromSuperview];
            src.view.alpha = 1.0f;
            [src.navigationController pushViewController:dest animated:NO];
        }];
    }];
}

@end
