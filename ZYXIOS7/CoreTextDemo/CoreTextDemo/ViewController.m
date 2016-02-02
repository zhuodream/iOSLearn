//
//  ViewController.m
//  CoreTextDemo
//
//  Created by 7road on 15/12/29.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "ViewController.h"
#import "CTDisplayView.h"
#import "CTFrameParserConfig.h"
#import "CoreTextData.h"
#import "CTFrameParser.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet CTDisplayView *ctView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
//    CTFrameParserConfig *config = [[CTFrameParserConfig alloc] init];
//    
//    config.width = self.ctView.width;
//    config.textColor = [UIColor blackColor];
    
//    CoreTextData *data = [CTFrameParser parseContent:@"按照以上原则，我们将‘CTDisplayView’ 中的部分内容拆开。" config:config];


//    NSString *content = @"对于上面的例子，我们给CTFramePaser增加了一个将NSString转"
//                        "换为CoreTextData的方法。"
//                        "但这样的实现方式有很多局限性，因为整个内容虽然可以定制字体"
//                        "大小，颜色，行高等信息，但是却不能定制内容中的某一部分。"
//                        "例如，如果我们只想让内容的前三个字显示成红色，而其他文字显"
//                        "示成黑色，那么就办不到了。"
//                        "\n\n"
//                        "解决的办法很简单，我们让‘CTFramePaser’支持接受"
//                        "NSAttributedString作为参数，然后在NSAttributedString中设置好"
//                        "我们想要的信息。";
//    NSDictionary *attr = [CTFrameParser attributiesWithConfig:config];
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content attributes:attr];
//    //在iOS7以上的系统中能够改变颜色，iOS9中无效
////    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 7)];
//    [attributedString addAttribute:(id)kCTForegroundColorAttributeName value:(id)[UIColor redColor].CGColor range:NSMakeRange(0, 7)];
//    
//    CoreTextData *data = [CTFrameParser parseAttributedContent:attributedString config:config];
//    self.ctView.data = data;
//    self.ctView.height = data.height;
//    self.ctView.backgroundColor = [UIColor yellowColor];
    
    CTFrameParserConfig *config = [[CTFrameParserConfig alloc] init];
    config.width = self.ctView.width;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"content" ofType:@"json"];
    CoreTextData *data = [CTFrameParser parseTemplateFile:path config:config];
    self.ctView.data = data;
    self.ctView.height = data.height;
    self.ctView.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
