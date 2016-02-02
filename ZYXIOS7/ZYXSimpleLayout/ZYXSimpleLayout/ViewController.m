//
//  ViewController.m
//  ZYXSimpleLayout
//
//  Created by 7road on 15/12/12.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "ViewController.h"
#import "CoreTextLabel.h"
@import CoreText;


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    CFMutableAttributedStringRef attrString;
    CTFontRef baseFont, boldFont, italicFont;
    
    //创建要显示的字符串，使用\n来进行换行
    CFStringRef string = CFSTR("Here is some simple text that includes bold and italics.\n"
        "\n"
        "We can even include some color");
    
    //创建可变的属性字符串
    attrString = CFAttributedStringCreateMutable(NULL, 0);
    CFAttributedStringReplaceString(attrString, CFRangeMake(0, 0), string);
    
    //设置基本的字体
    baseFont = CTFontCreateUIFontForLanguage(kCTFontUIFontUser, 16.0, NULL);
    CFIndex length = CFStringGetLength(string);
    CFAttributedStringSetAttribute(attrString, CFRangeMake(0, length), kCTFontAttributeName, baseFont);
    
    boldFont = CTFontCreateCopyWithSymbolicTraits(baseFont, 0, NULL, kCTFontBoldTrait, kCTFontBoldTrait);
    CFAttributedStringSetAttribute(attrString, CFStringFind(string, CFSTR("bold"), 0), kCTFontAttributeName, boldFont);
    
    italicFont = CTFontCreateCopyWithSymbolicTraits(baseFont, 0, NULL, kCTFontItalicTrait, kCTFontItalicTrait);
    
    CFAttributedStringSetAttribute(attrString, CFStringFind(string, CFSTR("italics"), 0), kCTFontAttributeName, italicFont);
    
    CGColorRef color = [[UIColor redColor] CGColor];
    CFAttributedStringSetAttribute(attrString, CFStringFind(string, CFSTR("color"), 0), kCTForegroundColorAttributeName, color);
    
    //最后一行居中
    CTTextAlignment alignment = kCTTextAlignmentCenter;
    CTParagraphStyleSetting setting = { kCTParagraphStyleSpecifierAlignment, sizeof(alignment), &alignment};
    
    CTParagraphStyleRef style = CTParagraphStyleCreate(&setting, 1);
    CFRange lastLineRange = CFStringFind(string, CFSTR("\n"), kCFCompareBackwards);
   
    
    ++lastLineRange.location;
    lastLineRange.length = CFStringGetLength(string) - lastLineRange.location;
    
    CFAttributedStringSetAttribute(attrString, lastLineRange, kCTParagraphStyleAttributeName, style);
    
    CoreTextLabel *label = [[CoreTextLabel alloc] initWithFrame:CGRectInset(self.view.bounds, 10, 10)];
    label.attributeString = (__bridge id)attrString;
    [self.view addSubview:label];
    
    CFRelease(style);
    CFRelease(attrString);
    CFRelease(baseFont);
    CFRelease(boldFont);
    CFRelease(italicFont);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
