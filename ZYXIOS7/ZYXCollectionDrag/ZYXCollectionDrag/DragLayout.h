//
//  DragLayout.h
//  ZYXCollectionDrag
//
//  Created by 7road on 15/12/4.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DragLayout : UICollectionViewFlowLayout

- (void)startDraggingIndexPath:(NSIndexPath *)indexPath fromPoint:(CGPoint)p;

- (void)updateDragLocation:(CGPoint)point;

- (void)stopDragging;

@end
