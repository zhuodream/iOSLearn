//
//  MenuBubbles.h
//  MenuButton
//
//  Created by 7road on 15/9/17.
//  Copyright (c) 2015年 7road. All rights reserved.
//

#import <UIKit/UIKit.h>

//前置声明
@protocol MenuBubblesDelegate;

typedef enum {
    MenuBubblesTypeFacebook = 0,
    MenuBubblesTypeTwitter = 1,
    MenuBubblesTypeGooglePlus = 2,
    MenuBubblesTypeMail = 3,
    MenuBubblesTypeTumblr = 4
} MenuBubblesType;


@interface MenuBubbles : UIView
{
    NSMutableArray *bubbles;
    
    UIView *bgView;
}

@property (nonatomic,weak) id<MenuBubblesDelegate> delegate;
//arc中使用unsafe_unretained代替assign  且是默认的
@property (nonatomic,assign) BOOL showFacebookBubble;
@property (nonatomic,assign) BOOL showTwitterBubble;
@property (nonatomic,assign) BOOL showMailBubble;
@property (nonatomic,assign) BOOL showGooglePlusBubble;
@property (nonatomic,assign) BOOL showThumblrBubble;

@property (nonatomic,assign) int radius;
@property (nonatomic,assign) int bubbleRadius;
@property (nonatomic,assign) BOOL isAnimating;
@property (nonatomic,weak) UIView *parentView;

@property (nonatomic,assign) int facebookBackgroundColorRGB;
@property (nonatomic,assign) int twitterBackgroundColorRGB;
@property (nonatomic,assign) int mailBackgroundColorRGB;
@property (nonatomic,assign) int googlePlusBackgroundColorRGB;
@property (nonatomic,assign) int thumblrBackgroundColorRGB;

- (instancetype)initWithPoint:(CGPoint)point radius:(int)radiusValue inView:(UIView *)inview;

- (void)show;
-(void)hide;

@end

@protocol MenuBubblesDelegate <NSObject>

- (void)menuShareBubbles:(MenuBubbles *)shareBubbles tappedBubbleWithType:(MenuBubblesType)bubbleType;

@end
