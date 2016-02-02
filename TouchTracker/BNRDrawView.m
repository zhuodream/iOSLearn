//
//  BNRDrawView.m
//  TouchTracker
//
//  Created by 7road on 15/7/25.
//  Copyright (c) 2015年 7road. All rights reserved.
//

#import "BNRDrawView.h"
#import "BNRLine.h"

@interface BNRDrawView () <UIGestureRecognizerDelegate>


@property (nonatomic,strong) UIPanGestureRecognizer *moveRecognizer;
//@property (nonatomic,strong) BNRLine *currentLine;
@property (nonatomic,strong) NSMutableDictionary *linesInProgress;
@property (nonatomic,strong) NSMutableArray *finishedLine;
//设置为弱引用，因为finishedLines数组会保存selectedLine对象，是强引用
@property (nonatomic,weak) BNRLine *selectedLine;


@end

@implementation BNRDrawView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    
    if(self)
    {
        self.linesInProgress=[[NSMutableDictionary alloc] init];
        self.finishedLine=[[NSMutableArray alloc]init];
        self.backgroundColor=[UIColor grayColor];
        //开启多点触摸
        self.multipleTouchEnabled=YES;
        
        
        //设置手势识别
        UITapGestureRecognizer *doubleTapRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        doubleTapRecognizer.numberOfTapsRequired=2;
        
        doubleTapRecognizer.delaysTouchesBegan=YES;
        //添加到视图中
        [self addGestureRecognizer:doubleTapRecognizer];
        
        UITapGestureRecognizer *tapRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        //防止同时识别单击和双击事件,设置tapRecognizer在单击后暂时不进行识别，确定不是双击手势后再识别
        [tapRecognizer requireGestureRecognizerToFail:doubleTapRecognizer];
        
        [self addGestureRecognizer:tapRecognizer];
        
        
        UILongPressGestureRecognizer *pressRecongizer=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
        
        [self addGestureRecognizer:pressRecongizer];
        
        self.moveRecognizer=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(moveLine:)];
        self.moveRecognizer.delegate=self;
        //设置是否吃掉所有和该手势有关的UITouch对象
        self.moveRecognizer.cancelsTouchesInView=NO;
        [self addGestureRecognizer:self.moveRecognizer];
    }
    
    return self;
}
//手势共享
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if(gestureRecognizer==self.moveRecognizer)
    {
        return YES;
    }
    return NO;
}

//拖动方法实现
-(void)moveLine:(UIPanGestureRecognizer *)gr
{
    if(!self.selectedLine)
        return ;
    

    //如果UIPanGestureRecognizer对象处于"变化后"状态
    if(gr.state==UIGestureRecognizerStateChanged&&![[UIMenuController sharedMenuController] isMenuVisible])
    {
        //获取手指的拖动距离
        CGPoint translation=[gr translationInView:self];
        
        //将拖移距离加至选中的线条的起点和终点
        CGPoint begin=self.selectedLine.begin;
        CGPoint end=self.selectedLine.end;
        begin.x+=translation.x;
        begin.y+=translation.y;
        end.x+=translation.x;
        end.y+=translation.y;
        
        //为选中的线条设置新的起点和终点
        self.selectedLine.begin=begin;
        self.selectedLine.end=end;
        
        [self setNeedsDisplay];
        //将手指当前位置设置为拖移手势的起始位置，并增量的报告拖移距离
        [gr setTranslation:CGPointZero inView:self];
    }
}


-(void)longPress:(UIGestureRecognizer *)gr
{
    if (self.selectedLine&&[[UIMenuController sharedMenuController] isMenuVisible]) {
        [[UIMenuController sharedMenuController] setMenuVisible:NO];
    }
    if(gr.state==UIGestureRecognizerStateBegan)
    {
        CGPoint point=[gr locationInView:self];
        self.selectedLine=[self lineAtPoint:point];
        
        if(self.selectedLine)
        {
            [self.linesInProgress removeAllObjects];
        }
    }
    else if (gr.state==UIGestureRecognizerStateEnded)
    {
        self.selectedLine=nil;
    }
    
    [self setNeedsDisplay];
}

-(void)doubleTap:(UIGestureRecognizer *)gr
{
    NSLog(@"Recognized Double Tap");
    
    [self.linesInProgress removeAllObjects];
    [self.finishedLine removeAllObjects];
    [self setNeedsDisplay];
}

-(void)tap:(UITapGestureRecognizer *)gr
{
    NSLog(@"Regonized tap");
    
    CGPoint point=[gr locationInView:self];
    self.selectedLine=[self lineAtPoint:point];
    
    if(self.selectedLine)
    {
        //使视图称为UIMenuItem动作消息的目标
        [self becomeFirstResponder];
        
        //获取UIMenuController对象,每个IOS应用只有一个UIMenuController对象
        UIMenuController *menu=[UIMenuController sharedMenuController];
        
        //创建一个新的标题为"Delete"的UIMenuItem对象
        UIMenuItem *deleteItem=[[UIMenuItem alloc] initWithTitle:@"Delete" action:@selector(deleteLine:)];
        menu.menuItems=@[deleteItem];
        
        //设置菜单对象的显示区域，并设置为可见
        [menu setTargetRect:CGRectMake(point.x, point.y, 2, 2) inView:self];
        [menu setMenuVisible:YES animated:YES];
            }
    else
    {
        //如果没有选中的线条，就隐藏
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
    }
    
    [self setNeedsDisplay];
}


-(void)deleteLine:(id)sender
{
    [self.finishedLine removeObject:self.selectedLine];
    
    [self setNeedsDisplay];
}

//如果将某个自定义的UIView子类对象设置为第一响应对象，必须要覆盖此方法
-(BOOL)canBecomeFirstResponder
{
    return YES;
}


-(void)strokeLine:(BNRLine *)line
{
    UIBezierPath *bp=[UIBezierPath bezierPath];
    bp.lineWidth=10;
    bp.lineCapStyle=kCGLineCapRound;
    
    [bp moveToPoint:line.begin];
    [bp addLineToPoint:line.end];
    [bp stroke];
}

-(void)drawRect:(CGRect)rect
{
    //用黑色绘制已经完成的线条
    [[UIColor blackColor]set];
    for(BNRLine *line in self.finishedLine)
    {
        [self strokeLine:line];
    }
    
    [[UIColor redColor] set];
    for (NSValue *key in self.linesInProgress) {
        [self strokeLine:self.linesInProgress[key]];
    }
    
    //用绿色绘制选中线条
    if(self.selectedLine)
    {
        [[UIColor greenColor] set];
        [self strokeLine:self.selectedLine];
    }
    
//    if(self.currentLine)
//    {
//        [[UIColor redColor]set];
//        [self strokeLine:self.currentLine];
//    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //向控制台输出日志，查看触摸时间发生顺序
    NSLog(@"%@",NSStringFromSelector(_cmd));
    
    if([[UIMenuController sharedMenuController] isMenuVisible])
    {
        self.selectedLine=nil;
        [[UIMenuController sharedMenuController] setMenuVisible:NO];
    }
    
    for (UITouch *t in touches) {
        CGPoint location=[t locationInView:self];
        
        BNRLine *line=[[BNRLine alloc] init];
        line.begin=location;
        line.end=location;
        
        //将UITouch的地址封装为NSValue对象，不能直接食用UITouch的对象作为键
        NSValue *key=[NSValue valueWithNonretainedObject:t];
        self.linesInProgress[key]=line;
    }
//    UITouch *t=[touches anyObject];
//    
//    //根据触摸位置创建BNRLine对象
//    CGPoint location=[t locationInView:self];
//    
//    self.currentLine=[[BNRLine alloc] init];
//    self.currentLine.begin=location;
//    self.currentLine.end=location;
    
    [self setNeedsDisplay];
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
//    UITouch *t=[touches anyObject];
//    CGPoint location=[t locationInView:self];
//    
//    self.currentLine.end=location;
    //向控制台输出日志，查看触摸时间发生的顺序
    NSLog(@"%@",NSStringFromSelector(_cmd));
    
    for (UITouch  *t in touches) {
        NSValue *key=[NSValue valueWithNonretainedObject:t];
        BNRLine *line=self.linesInProgress[key];
        
        line.end=[t locationInView:self];
    }
    
    
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
//    [self.finishedLine addObject:self.currentLine];
//    
//    self.currentLine=nil;

    //向控制台输出日志，查看触摸事件发生的顺序
    NSLog(@"%@",NSStringFromSelector(_cmd));
    
    for (UITouch *t in touches) {
        NSValue *key=[NSValue valueWithNonretainedObject:t];
        BNRLine *line=self.linesInProgress[key];
        
        [self.finishedLine addObject:line];
        [self.linesInProgress removeObjectForKey:key];
    }
    
    
    [self setNeedsDisplay];
}

//处理触摸取消事件
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    //向控制台输出日志，查看触摸事件发生的顺序
    NSLog(@"%@",NSStringFromSelector(_cmd));
    
    for (UITouch *t in touches) {
        NSValue *key=[NSValue valueWithNonretainedObject:t];
        [self.linesInProgress removeObjectForKey:key];
    }
    
    [self setNeedsDisplay];
}

//找出选中线条
-(BNRLine *)lineAtPoint:(CGPoint)p
{
    //找出离p最近的BNRLine对象
    for(BNRLine *l in self.finishedLine)
    {
        CGPoint start=l.begin;
        CGPoint end=l.end;
        
        //检查线条的若干点
        for(float t=0.0;t<=1.0;t+=0.05)
        {
            float x=start.x+t*(end.x-start.x);
            float y=start.y+t*(end.y-start.y);
            
            //如果线条的某个点和p的距离在20点以内，就返回相应的BNRLine对象
            if(hypot(x-p.x, y-p.y)<20.0)
            {
                return l;
            }
        }
    }
    
    return  nil;
}



@end
