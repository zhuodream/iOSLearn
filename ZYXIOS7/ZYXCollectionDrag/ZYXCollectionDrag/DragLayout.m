//
//  DragLayout.m
//  ZYXCollectionDrag
//
//  Created by 7road on 15/12/4.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "DragLayout.h"

@interface DragLayout ()

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIAttachmentBehavior *behavior;

@end

@implementation DragLayout

- (void)startDraggingIndexPath:(NSIndexPath *)indexPath fromPoint:(CGPoint)p
{
    self.indexPath = indexPath;
    self.animator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
    
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    attributes.zIndex += 1;
    
    self.behavior = [[UIAttachmentBehavior alloc] initWithItem:attributes attachedToAnchor:p];
    
    self.behavior.length = 0;
    self.behavior.frequency = 10;
    [self.animator addBehavior:self.behavior];
    
    
    //增加一点排斥力保持稳定
    UIDynamicItemBehavior *dynamicItem = [[UIDynamicItemBehavior alloc] initWithItems:@[attributes]];
    dynamicItem.resistance = 10;
    [self.animator addBehavior:dynamicItem];
    
    [self updateDragLocation:p];
}

- (void)updateDragLocation:(CGPoint)point
{
    self.behavior.anchorPoint = point;
}

- (void)stopDragging
{
    //move back to the original location (super)
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:self.indexPath];
    [self updateDragLocation:attributes.center];
    self.indexPath = nil;
    self.behavior = nil;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    // Find all the attributes, and replace the one for our indexPath
    NSArray *existingAttributes = [super
                                   layoutAttributesForElementsInRect:rect];
    NSMutableArray *allAttributes = [NSMutableArray new];
    for (UICollectionViewLayoutAttributes *a in existingAttributes) {
        if (![a.indexPath isEqual:self.indexPath]) {
            [allAttributes addObject:a];
        }
    }
    
    [allAttributes addObjectsFromArray:[self.animator itemsInRect:rect]];
    return allAttributes;
}

@end
