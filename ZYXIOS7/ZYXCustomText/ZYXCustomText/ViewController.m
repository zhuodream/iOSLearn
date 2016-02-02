//
//  ViewController.m
//  ZYXCustomText
//
//  Created by 7road on 15/12/9.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "ViewController.h"
#import "ZYXScribbleTextStorage.h"
#import "ZYXLayoutManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"sample.txt" ofType:nil];
    NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:string];
    
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    [style setAlignment:NSTextAlignmentJustified];
    
    ZYXScribbleTextStorage *text = [[ZYXScribbleTextStorage alloc] init];
    
    text.tokens = @{ @"France" : @{ NSForegroundColorAttributeName :
                                        [UIColor blueColor] },
                     @"England" : @{ NSForegroundColorAttributeName :
                                         [UIColor redColor] },
                     @"season" : @{ZYXRedactStyleAttributeName :
                                       @YES },
                     @"and" : @{ZYXHighlightColorAttributeName :
                                    [UIColor yellowColor] },
                     ZYXDefaultTokenName : @{
                             NSParagraphStyleAttributeName: style,
                             NSFontAttributeName:
                                 [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2],
                             } };

    
    [text setAttributedString:attributedString];
    //PTLScribbleLayoutManager *layoutManager = [PTLScribbleLayoutManager new];
//    NSLayoutManager *layoutManager = [NSLayoutManager new];
    ZYXLayoutManager *layoutManager = [[ZYXLayoutManager alloc] init];
    [text addLayoutManager:layoutManager];
    
    CGRect textViewFrame = CGRectMake(30, 40, 708, 400);
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:textViewFrame.size];
    [layoutManager addTextContainer:textContainer];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:textViewFrame textContainer:textContainer];
    [self.view addSubview:textView];
}



@end
