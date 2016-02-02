//
//  MenuBubbles.m
//  MenuButton
//
//  Created by 7road on 15/9/17.
//  Copyright (c) 2015年 7road. All rights reserved.
//

#import "MenuBubbles.h"
#import <QuartzCore/QuartzCore.h>

@interface MenuBubbles()

@end

@implementation MenuBubbles

- (instancetype)initWithPoint:(CGPoint)point radius:(int)radiusValue inView:(UIView *)inview
{
    self = [super initWithFrame:CGRectMake(point.x-radiusValue, point.y-radiusValue, 2*radiusValue, 2*radiusValue)];
    if(self)
    {
        self.radius=radiusValue;
        self.bubbleRadius=40;
        self.parentView=inview;
        
        self.facebookBackgroundColorRGB = 0x3c5a9a;
        self.twitterBackgroundColorRGB = 0x3083be;
        self.mailBackgroundColorRGB = 0xbb54b5;
        self.googlePlusBackgroundColorRGB = 0xd95433;
        self.thumblrBackgroundColorRGB = 0x385877;
    }
    return self;
}

#pragma mark -
#pragma mark Actions

- (void)facebookTapped
{
    [self shareButtonTappedWithType:MenuBubblesTypeFacebook];
}

- (void)twitterTapped
{
    [self shareButtonTappedWithType:MenuBubblesTypeTwitter];
}

- (void)mailTapped
{
    [self shareButtonTappedWithType:MenuBubblesTypeMail];
}

- (void)googlePlusTapped
{
    [self shareButtonTappedWithType:MenuBubblesTypeGooglePlus];
}

- (void)thumblrTapped
{
    [self shareButtonTappedWithType:MenuBubblesTypeTumblr];
}

- (void)shareButtonTappedWithType:(MenuBubblesType)buttonType
{
    [self hide];
    if([self.delegate respondsToSelector:@selector(menuShareBubbles:tappedBubbleWithType:)])
    {
        [self.delegate menuShareBubbles:self tappedBubbleWithType:buttonType];
    }
}


- (void)show
{
    if(!self.isAnimating)
    {
        self.isAnimating = YES;
        [self.parentView addSubview:self];
        
        bgView=[[UIView alloc] initWithFrame:self.parentView.bounds];
        UITapGestureRecognizer *tapges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareViewBackgroundTapped:)];
        [bgView addGestureRecognizer:tapges];
        [_parentView addSubview:bgView];
        [_parentView insertSubview:bgView belowSubview:self];
        
        if(bubbles)
        {
            bubbles = nil;
        }
        bubbles=[[NSMutableArray alloc] init];
        if(self.showFacebookBubble)
        {
            UIButton *facebookBubble = [self shareButtonWithIcon:@"icon-aa-facebook.png" andBackgroundColorRGB:self.facebookBackgroundColorRGB];
            [facebookBubble addTarget:self action:@selector(facebookTapped) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:facebookBubble];
            [bubbles addObject:facebookBubble];
        }
        if(self.showTwitterBubble)
        {
            UIButton *twitterBubble = [self shareButtonWithIcon:@"icon-aa-twitter.png" andBackgroundColorRGB:self.twitterBackgroundColorRGB];
            [twitterBubble addTarget:self action:@selector(twitterTapped) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:twitterBubble];
            [bubbles addObject:twitterBubble];
        }
        if(self.showGooglePlusBubble)
        {
            UIButton *goolePlusBubble = [self shareButtonWithIcon:@"icon-aa-googlePlus.png" andBackgroundColorRGB:self.googlePlusBackgroundColorRGB];
            [goolePlusBubble addTarget:self action:@selector(googlePlusTapped) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:goolePlusBubble];
            [bubbles addObject:goolePlusBubble];
        }
        if(self.showThumblrBubble)
        {
            UIButton *thumblrBubble = [self shareButtonWithIcon:@"icon-aa-tumblr.png" andBackgroundColorRGB:self.thumblrBackgroundColorRGB];
            [thumblrBubble addTarget:self action:@selector(thumblrTapped) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:thumblrBubble];
            [bubbles addObject:thumblrBubble];
        }
        if(self.showMailBubble)
        {
            UIButton *mainBubble = [self shareButtonWithIcon:@"icon-aa-at.png" andBackgroundColorRGB:self.mailBackgroundColorRGB];
            [mainBubble addTarget:self action:@selector(mailTapped) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:mainBubble];
            [bubbles addObject:mainBubble];
        }
        
        if(bubbles.count == 0) return;
        
        float bubbleDistanceFromPivot = self.radius - self.bubbleRadius;
        float bubbleBetweenAngel = 360 / bubbles.count;
        float angely = (180 - bubbleBetweenAngel) * 0.5;
        float startAngel = 180 - angely;
        
        NSMutableArray *coordinates = [NSMutableArray array];
        
        for(int i = 0; i < bubbles.count; ++i)
        {
            UIButton *bubble = [bubbles objectAtIndex:i];
            bubble.tag = i;
            
            float angle = startAngel + i*bubbleBetweenAngel;
            float x = cos(angle * M_PI / 180) * bubbleDistanceFromPivot + self.radius;
            float y = sin(angle * M_PI / 180) * bubbleDistanceFromPivot + self.radius;
            
            [coordinates addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithFloat:x],@"x",
                                    [NSNumber numberWithFloat:y],@"y",
                                    nil]];
            
            bubble.transform = CGAffineTransformMakeScale(0.001, 0.001);
            //bubble.transform = CGAffineTransformMakeRotation(15);
            bubble.center = CGPointMake(self.radius, self.radius);
        }
        
        int inetratorI = 0;
        for(NSDictionary *coordinate in coordinates)
        {
            UIButton *bubble = [bubbles objectAtIndex:inetratorI];
            float delayTime = inetratorI * 0.1;
            [self performSelector:@selector(showBubbleWithAnimation:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                  bubble,@"button",
                                                                                  coordinate,@"coordinate",
                                                                                  nil] afterDelay:delayTime];
            ++inetratorI;
            
        }
    }
}

- (void)hide
{
    if(!self.isAnimating)
    {
        self.isAnimating = YES;
        int inetratorI = 0;
        for(UIButton *bubble in bubbles)
        {
            float delayTime = inetratorI * 0.1;
            [self performSelector:@selector(hideBubbleWithAnimation:) withObject:bubble afterDelay:delayTime];
            ++inetratorI;
        }
    }
}

#pragma mark -
#pragma mark Helper functions

- (void)shareViewBackgroundTapped:(UIGestureRecognizer *)tapGesture
{
    [tapGesture.view removeFromSuperview];
    [self hide];
}

- (void)showBubbleWithAnimation:(NSDictionary *)info
{
    UIButton *bubble = (UIButton *)[info objectForKey:@"button"];
    NSDictionary *coordinate = (NSDictionary *)[info objectForKey:@"coordinate"];
    
    [UIView animateWithDuration:0.25 animations:^{
        bubble.center = CGPointMake([[coordinate objectForKey:@"x"] floatValue],[[coordinate objectForKey:@"y"] floatValue]);
        bubble.alpha = 1;
        bubble.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 animations:^{
            bubble.transform = CGAffineTransformMakeScale(0.8, 0.8);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.15 animations:^{
                bubble.transform = CGAffineTransformMakeScale(1, 1);
            } completion:^(BOOL finished) {
                if(bubble.tag == bubbles.count - 1) self.isAnimating = NO;
                bubble.layer.shadowColor = [UIColor blackColor].CGColor;
                bubble.layer.shadowOpacity = 0.2;
                bubble.layer.shadowOffset = CGSizeMake(0, 1);
                bubble.layer.shadowRadius = 2;
            }];
        }];
    }];
}

- (void)hideBubbleWithAnimation:(UIButton *)bubble
{
    [UIView animateWithDuration:0.2 animations:^{
        bubble.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 animations:^{
            bubble.center = CGPointMake(self.radius, self.radius);
            bubble.transform = CGAffineTransformMakeScale(0.001, 0.001);
            //bubble.transform = CGAffineTransformMakeRotation(15);
            bubble.alpha = 0;
        } completion:^(BOOL finished) {
            if(bubble.tag == bubbles.count - 1)
            {
                self.isAnimating = NO;
                self.hidden = YES;
                [bgView removeFromSuperview];
                bgView = nil;
                [self removeFromSuperview];
            }
            [bubble removeFromSuperview];
        }];
    }];
}

- (UIButton *)shareButtonWithIcon:(NSString *)iconName andBackgroundColorRGB:(int)rgb
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 2*self.bubbleRadius, 2*self.bubbleRadius);
  
    //圆形背景
    UIView *circle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2*self.bubbleRadius, 2*self.bubbleRadius)];
    circle.backgroundColor = [self colorFromRGB:rgb];
    circle.layer.cornerRadius = self.bubbleRadius;
    //裁剪
    circle.layer.masksToBounds = YES;
    //透明性
    circle.opaque = NO;
    circle.alpha = 0.97;
    
    //圆形角标
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconName]];
    CGRect f = icon.frame;
    f.origin.x = (circle.frame.size.width - f.size.width) * 0.5;
    f.origin.y = (circle.frame.size.height - f.size.height) * 0.5;
    icon.frame = f;
    [circle  addSubview:icon];
    
    [button setBackgroundImage:[self imageWithView:circle] forState:UIControlStateNormal];
    
    return button;
}

- (UIColor *)colorFromRGB:(int)rgb
{
    return [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16)) / 255.0 green:((float)((rgb & 0xFF00) >> 8)) / 255.0 blue:((float)(rgb &0xFF)) / 255.0 alpha:1.0];
}

- (UIImage *)imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
