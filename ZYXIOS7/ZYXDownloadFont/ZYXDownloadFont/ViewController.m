//
//  ViewController.m
//  ZYXDownloadFont
//
//  Created by 7road on 15/12/28.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "ViewController.h"
@import CoreText;

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ViewController
- (IBAction)buttonTouchUpInside:(id)sender
{
    NSLog(@"title = %@", self.button.currentTitle);
    [self asynchronouslySetFontName:self.button.currentTitle];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)asynchronouslySetFontName:(NSString *)fontName
{
    UIFont *font = [UIFont fontWithName:fontName size:12.];
    NSLog(@"FONT NAME = %@", font);
    
    if (font && ([font.fontName compare:fontName] == NSOrderedSame || [font.familyName compare:fontName] == NSOrderedSame))
    {
        _textView.text = @"下载的新字体";
        _textView.font = [UIFont fontWithName:fontName size:24.];
        return;
    }
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionaryWithObjectsAndKeys:fontName, kCTFontNameAttribute, nil];
    
    CTFontDescriptorRef desc = CTFontDescriptorCreateWithAttributes((__bridge CFDictionaryRef)attrs);
    
    NSMutableArray *descs = [NSMutableArray arrayWithCapacity:0];
    [descs addObject:(__bridge id)desc];
    
    CFRelease(desc);
    
    __block BOOL errorDuringDownload = NO;
    
    //下载字体
    CTFontDescriptorMatchFontDescriptorsWithProgressHandler((__bridge CFArrayRef)descs, NULL, ^bool(CTFontDescriptorMatchingState state, CFDictionaryRef  _Nonnull progressParameter) {
        double progressValue = [[(__bridge NSDictionary *)progressParameter objectForKey:(id)kCTFontDescriptorMatchingPercentage] doubleValue];
        
        if (state == kCTFontDescriptorMatchingDidBegin)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                _textView.text = [NSString stringWithFormat:@"Downloading %@", fontName];
                _textView.font = [UIFont systemFontOfSize:14.];
                NSLog(@"Begin Matching");
            });
        }
        else if (state == kCTFontDescriptorMatchingDidFinish)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                _textView.text = @"下载的新字体";
                _textView.font = [UIFont fontWithName:fontName size:24.];
                
                CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)fontName, 0., NULL);
                CFStringRef fontURL = CTFontCopyAttribute(fontRef, kCTFontURLAttribute);
                NSLog(@"%@", (__bridge NSString *)(fontURL));
                
                CFRelease(fontURL);
                CFRelease(fontRef);
                
                if (!errorDuringDownload)
                {
                    NSLog(@"%@ downloaded ", fontName);
                }
            });
        }
        else if (state == kCTFontDescriptorMatchingWillBeginDownloading)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Begin Downloading");
            });
        }
        else if (state == kCTFontDescriptorMatchingDidFinishDownloading)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"finish Downloading");
            });
        }
        else if (state == kCTFontDescriptorMatchingDownloading)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Downloading % .0f%% complete", progressValue);
            });
        }
        else if (state == kCTFontDescriptorMatchingDidFailWithError)
        {
            NSError *error = [(__bridge NSDictionary *)progressParameter objectForKey:(id)kCTFontDescriptorMatchingError];
            if(error != nil)
            {
                NSLog(@"error = %@", [error description]);
            }
            
            errorDuringDownload  = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Download error = %@", [error description]);
            });
        }
        
        return (bool)YES;
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
