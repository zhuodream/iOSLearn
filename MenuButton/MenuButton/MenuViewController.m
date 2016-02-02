//
//  MenuViewController.m
//  MenuButton
//
//  Created by 7road on 15/9/17.
//  Copyright (c) 2015年 7road. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuBubbles.h"
@interface MenuViewController () <MenuBubblesDelegate>

@end

@implementation MenuViewController
{
    MenuBubbles *shareBubbles;
    float radius;
    float bubbleRadius;
}

////xib文件修改按钮位置必须在这里修改
//- (void)viewDidLayoutSubviews
//{
//    [super viewDidLayoutSubviews];
//        CGPoint center = [_shareButton center];
//        NSLog(@"center====%f,%f",center.x,center.y);
//        center.x+=100;
//        center.y+=100;
//        _shareButton.center = center;
//        NSLog(@"shareButton====%f,%f",_shareButton.center.x,_shareButton.center.y);
//
//}

//修改位置也可以在这里设置
//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    
//    [super viewDidLayoutSubviews];
//    CGPoint center = [_shareButton center];
//    NSLog(@"center====%f,%f",center.x,center.y);
//    center.x+=100;
//    center.y+=100;
//    _shareButton.center = center;
//    NSLog(@"shareButton====%f,%f",_shareButton.center.x,_shareButton.center.y);
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    radius = 122;
    bubbleRadius = 40;
    _radiusSlider.value = radius;
    _bubbleSlider.value = bubbleRadius;
    
    _radiusLabel.text = [NSString stringWithFormat:@"%.0f",radius];
    _bubbleLabel.text = [NSString stringWithFormat:@"%.0f",bubbleRadius];
}

- (IBAction)shareTapped:(id)sender
{
    if(shareBubbles)
    {
        shareBubbles = nil;
    }
//    CGPoint center = [_shareButton center];
//    NSLog(@"center====%f,%f",center.x,center.y);
//    center.x+=100;
//    center.y+=500;
//    _shareButton.center = center;
//    NSLog(@"shareButton====%f,%f",_shareButton.center.x,_shareButton.center.y);
    shareBubbles = [[MenuBubbles alloc] initWithPoint:_shareButton.center radius:radius inView:self.view];
    shareBubbles.delegate = self;
    shareBubbles.bubbleRadius = bubbleRadius;
    shareBubbles.showFacebookBubble = YES;
    shareBubbles.showGooglePlusBubble = YES;
    shareBubbles.showMailBubble = YES;
    shareBubbles.showThumblrBubble = YES;
    shareBubbles.showTwitterBubble = YES;
    [shareBubbles show];
}

- (IBAction)radiusValueChanger:(id)sender
{
    radius = [(UISlider *)sender value];
    _radiusLabel.text = [NSString stringWithFormat:@"%.0f",radius];
}

- (IBAction)bubbleRadiusValueChanger:(id)sender
{
    bubbleRadius = [(UISlider *)sender value];
    _bubbleLabel.text = [NSString stringWithFormat:@"%0.f",bubbleRadius];
}


#pragma mark -
#pragma mark MenuShareBubbles

- (void) menuShareBubbles:(MenuBubbles *)shareBubbles tappedBubbleWithType:(MenuBubblesType)bubbleType
{
    
    switch (bubbleType) {
        case MenuBubblesTypeFacebook:
            NSLog(@"Facebook");
            break;
        case MenuBubblesTypeTwitter:
            NSLog(@"Twitter");
            break;
        case MenuBubblesTypeGooglePlus:
            NSLog(@"GooglePlus");
            break;
        case MenuBubblesTypeMail:
            NSLog(@"Eamil");
            break;
        case MenuBubblesTypeTumblr:
            NSLog(@"Thumblr");
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
