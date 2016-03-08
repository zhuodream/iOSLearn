//
//  ZYXCircleAnimateView.h
//  SQ-PhonePlug
//
//  Created by 7road on 16/1/21.
//  Copyright © 2016年 zhuo. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface ZYXCircleAnimateView : UIView

@property (nonatomic, assign) IBInspectable CGFloat progressLineWidth;

@property (nonatomic, assign) IBInspectable CGFloat backgroundLineWidth;

@property (nonatomic, assign) IBInspectable CGFloat progress;

@property (nonatomic, strong) IBInspectable UIColor *backgroundStrokeColor;

@property (nonatomic, strong) IBInspectable UIColor *progressStrokenColor;


- (void)startAnimation;

- (void)stopAnimation;

@end
