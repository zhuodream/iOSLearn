//
//  HypnosisViewController.m
//  HypneNerd
//
//  Created by 7road on 15/7/23.
//  Copyright (c) 2015年 7road. All rights reserved.
//

#import "HypnosisViewController.h"
#import "HypnosisView.h"
//委托的声明
@interface HypnosisViewController() <UITextFieldDelegate>
@property(nonatomic,weak) UITextField *textField;
@end

@implementation HypnosisViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self)
    {
        
        //设置标签项标题
        self.tabBarItem.title=@"Hypnotize";
        //从图像文件创建一个UIImage对象
        UIImage *i=[UIImage imageNamed:@"Hypno.png"];
        
        self.tabBarItem.image=i;
    }
    return self;
}

//覆盖父类方法
-(void) loadView
{
    HypnosisView *backgroundView=[[HypnosisView alloc] init];
    
    //CGRect textFieldRect=CGRectMake(40, 70, 240, 30);
    CGRect textFieldRect=CGRectMake(40, -20, 240, 30);
    UITextField *textField=[[UITextField alloc] initWithFrame:textFieldRect];
    
    //设置UITextField对象的边框样式，便于查看它在屏幕上的位置
    textField.borderStyle=UITextBorderStyleRoundedRect;
    textField.placeholder=@"Hypnotize me";
    textField.returnKeyType=UIReturnKeyDone;
    
    //设置UITextField的委托为HypnosisViewController对象，此时会有警告
    textField.delegate=self;
    
    [backgroundView addSubview:textField];
    
    self.textField=textField;
    self.view=backgroundView;
}

-(void)viewDidLoad
{
    //必须调用父类的实现
    [super viewDidLoad];
    
    NSLog(@"HypnosisViewController loaded its view.");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
}


- (void)keyboardShow:(NSNotification *)notification
{
    NSLog(@"aa");
    NSDictionary *info = [notification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSLog(@"duration = %f", duration);
    CGRect beginKeyboardRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat yOffset =beginKeyboardRect.origin.y - endKeyboardRect.origin.y;
    NSLog(@"yset = %f", yOffset);
    
    CGRect inputFieldRect = self.textField.frame;
    inputFieldRect.origin.y = 300;
    
    [UIView animateWithDuration:duration animations:^{
        self.textField.frame = inputFieldRect;
    }];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:2.0 delay:0.0 usingSpringWithDamping:0.25 initialSpringVelocity:0.0 options:0 animations:^{
        CGRect frame=CGRectMake(40, 70, 240, 30);
        self.textField.frame=frame;
    } completion:NULL];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"%@",textField.text);
    [self drawHypnoticMessage:textField.text];
    
    textField.text=@"";
    [textField resignFirstResponder];
    
    return YES;
}

-(void) drawHypnoticMessage:(NSString *)message
{
    for(int i=0;i<20;i++)
    {
        UILabel * messageLabel=[[UILabel alloc] init];
        
        //设置UILabel对应的文字和颜色
        messageLabel.backgroundColor=[UIColor clearColor];
        messageLabel.textColor=[UIColor whiteColor];
        messageLabel.text=message;
        
        //根据需要显示的文字调整UILabel对象的大小
        [messageLabel sizeToFit];
        
        //获取随机x坐标
        //使UILabel对象的宽度不超出HypnosisViewController的view宽度
        int width=(int)(self.view.bounds.size.width-messageLabel.bounds.size.width);
        int x=arc4random()%width;
        
        //获取随机y坐标
        //使UILabel对象的高度不超出HypnosisViewController的view高度
        int height=(int)(self.view.bounds.size.height-messageLabel.bounds.size.height);
        int y=arc4random()%height;
        
        //设置UILabel对象的frame
        CGRect frame=messageLabel.frame;
        frame.origin=CGPointMake(x, y);
        messageLabel.frame=frame;
        
        [self.view addSubview:messageLabel];
        
        //设置messageLabel的透明度的起始值
        messageLabel.alpha=0.0;
        
        //让messageLabel的透明度由0.0变为1.0
//        [UIView animateWithDuration:0.5 animations:^{
//            messageLabel.alpha=1.0;
//        }];

        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            messageLabel.alpha=1.0;
        } completion:NULL];
        
        [UIView animateKeyframesWithDuration:1.0 delay:0.0 options:0 animations:^{
            [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.8 animations:^{
                messageLabel.center=self.view.center;
            }];
            
            [UIView addKeyframeWithRelativeStartTime:0.8 relativeDuration:0.2 animations:^{
                int x=arc4random()%width;
                int y=arc4random()%height;
                messageLabel.center=CGPointMake(x, y);
            }];
        } completion:^(BOOL finished){
            NSLog(@"Animation finished");
        }];
        
        UIInterpolatingMotionEffect *motionEffect=[[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        motionEffect.minimumRelativeValue=@(-25);
        motionEffect.maximumRelativeValue=@(25);
        [messageLabel addMotionEffect:motionEffect];
        
        motionEffect=[[UIInterpolatingMotionEffect alloc]
                      initWithKeyPath:@"center.y"
                    type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        motionEffect.minimumRelativeValue=@(-25);
        motionEffect.maximumRelativeValue=@(25);
        [messageLabel addMotionEffect:motionEffect];
        
    }
}

@end
