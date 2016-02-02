//
//  ViewController.m
//  ZYXTearOff
//
//  Created by 7road on 15/12/4.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "ViewController.h"
#import "DraggableView.h"
#import "TearOffBehavior.h"
#import "DefaultBehavior.h"

const CGFloat kShapeDimension = 100.0;
const NSUInteger kSliceCount = 6;

@interface ViewController ()

@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) DefaultBehavior *defaultBehavior;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    CGRect frame = CGRectMake(0, 0, kShapeDimension, kShapeDimension);
    
    DraggableView *dragView = [[DraggableView alloc] initWithFrame:frame animator:self.animator];
    dragView.center = CGPointMake(self.view.center.x / 4, self.view.center.y / 4);
    dragView.alpha = 0.5;
    
    [self.view addSubview:dragView];
    
    DefaultBehavior *defaultBehavior = [DefaultBehavior new];
    [self.animator addBehavior:defaultBehavior];
    self.defaultBehavior = defaultBehavior;
    
    TearOffBehavior *tearOffBehavior = [[TearOffBehavior alloc] initWithDraggableView:dragView anchor:dragView.center handler:^(DraggableView *tornView, DraggableView *newPinView) {
        tornView.alpha = 1;
        [defaultBehavior addItem:tornView];
        //双击粉碎
        UITapGestureRecognizer *t = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(trash:)];
        t.numberOfTapsRequired = 2;
        [tornView addGestureRecognizer:t];
    }];
    
    [self.animator addBehavior:tearOffBehavior];
}

- (void)trash:(UIGestureRecognizer *)g
{
    UIView *view = g.view;
    
    //计算新的视图
    NSArray *subViews = [self sliceView:view intoRows:kSliceCount columns:kSliceCount];
    
    //创建一个新的动画类
    UIDynamicAnimator *trashAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    //创建一个新的默认行为
    DefaultBehavior *defaultBehavior = [DefaultBehavior new];
    
    for (UIView *subview in subViews)
    {
        //向层次结构中添加新的爆炸视图
        [self.view addSubview:subview];
        [defaultBehavior addItem:subview];
        
        UIPushBehavior * push = [[UIPushBehavior alloc] initWithItems:@[subview] mode:UIPushBehaviorModeInstantaneous];
        [push setPushDirection:CGVectorMake((float)rand()/RAND_MAX - .5, (float)rand()/RAND_MAX - .5)];
        
        [trashAnimator addBehavior:push];
        
        //淡出到处飞的碎片
        //最终删除他们
        //这里引用trashAnimator还会让ARC不必使用实例变量
        [UIView animateWithDuration:1 animations:^{
            subview.alpha = 0;
        } completion:^(BOOL finished) {
            [subview removeFromSuperview];
            [trashAnimator removeBehavior:push];
        }];
    }
    
    //删除旧视图
    [self.defaultBehavior removeItem:view];
    [view removeFromSuperview];
}

- (NSArray *)sliceView:(UIView *)view intoRows:(NSUInteger)rows columns:(NSInteger)columns
{
    UIGraphicsBeginImageContext(view.bounds.size);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
    CGImageRef image = [UIGraphicsGetImageFromCurrentImageContext() CGImage];
    UIGraphicsEndImageContext();
    
    NSMutableArray *views = [NSMutableArray new];
    CGFloat width = CGImageGetWidth(image);
    CGFloat height = CGImageGetHeight(image);
    for (NSUInteger row = 0; row < rows; ++row)
    {
        for (NSUInteger column = 0; column < columns; ++column)
        {
            CGRect rect = CGRectMake(column*(width / columns), row*(height / rows), width / columns, height / rows);
            
            CGImageRef subimage = CGImageCreateWithImageInRect(image, rect);
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:subimage]];
            CGImageRelease(subimage);
            subimage = NULL;
            
            imageView.frame = CGRectOffset(rect, CGRectGetMinX(view.frame), CGRectGetMinY(view.frame));
            
            [views addObject:imageView];
        }
    }
    
    return views;
}

@end
