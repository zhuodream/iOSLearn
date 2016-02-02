//
//  DraggableView.h
//  ZYXTearOff
//
//  Created by 7road on 15/12/4.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DraggableView : UIView <NSCopying>

- (instancetype)initWithFrame:(CGRect)frame animator:(UIDynamicAnimator *)animator;

@end
