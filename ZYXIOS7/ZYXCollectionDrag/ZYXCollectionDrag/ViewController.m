//
//  ViewController.m
//  ZYXCollectionDrag
//
//  Created by 7road on 15/12/4.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "ViewController.h"
#import "DragLayout.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
}

- (IBAction)handleLongPress:(UIGestureRecognizer *)g
{
    DragLayout *dragLayout = (DragLayout *)self.collectionViewLayout;
    CGPoint location = [g locationInView:self.collectionView];
    
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];
    
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    
    UIGestureRecognizerState state = g.state;
    if (state == UIGestureRecognizerStateBegan)
    {
        //改变选中的颜色
        [UIView animateWithDuration:0.25 animations:^{
            cell.backgroundColor = [UIColor redColor];
        }];
        NSLog(@"location = %@", NSStringFromCGPoint(location));
        [dragLayout startDraggingIndexPath:indexPath fromPoint:location];
    }
    else if (state == UIGestureRecognizerStateEnded || state == UIGestureRecognizerStateCancelled)
    {
        //改变颜色，并且停止拖拽
        [UIView animateWithDuration:0.25 animations:^{
            cell.backgroundColor = [UIColor lightGrayColor];
        }];
        [dragLayout stopDragging];
    }
    else
    {
        NSLog(@"location = %@", NSStringFromCGPoint(location));
        //拖拽
        [dragLayout updateDragLocation:location];
    }
}





@end
