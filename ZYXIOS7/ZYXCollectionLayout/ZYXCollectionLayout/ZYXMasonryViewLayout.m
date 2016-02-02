//
//  ZYXMasonryViewLayout.m
//  ZYXCollectionLayout
//
//  Created by 7road on 15/10/9.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "ZYXMasonryViewLayout.h"

@interface ZYXMasonryViewLayout()

@property (nonatomic, strong) NSMutableDictionary *lastYValueForColumn;
@property (strong, nonatomic) NSMutableDictionary *layoutInfo;

@end

@implementation ZYXMasonryViewLayout

//布局需要覆盖的三个方法

- (void)prepareLayout
{
    self.numberofColumns = 3;
    self.interItemSpacing = 12.5;
    
    self.delegate = (id<ZYXMasonryViewLayoutDelegate>)self.collectionView.delegate;
    self.lastYValueForColumn = [NSMutableDictionary dictionary];
    CGFloat currentColumn = 0;
    CGFloat fullWidth = self.collectionView.frame.size.width;
    CGFloat availableSpaceExcludingPadding = fullWidth - (self.interItemSpacing * (self.numberofColumns + 1));
    CGFloat itemWidth = availableSpaceExcludingPadding / self.numberofColumns;
    self.layoutInfo = [NSMutableDictionary dictionary];
    NSIndexPath *indexPath;
    NSInteger numSections = [self.collectionView numberOfSections];
    
    for (NSInteger section = 0; section < numSections; section++)
    {
        NSInteger numItems = [self.collectionView numberOfItemsInSection:section];
        for (NSInteger item = 0; item < numItems; item++) {
            indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            
            UICollectionViewLayoutAttributes *itemAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            
            CGFloat x = self.interItemSpacing + (self.interItemSpacing + itemWidth) * currentColumn;
            CGFloat y = [self.lastYValueForColumn[@(currentColumn)] doubleValue];
            CGFloat height = [self.delegate collectionView:self.collectionView layout:self heightForItemAtIndexPath:indexPath];
            
            itemAttributes.frame = CGRectMake(x, y, itemWidth, height);
            y += height;
            y += self.interItemSpacing;
            
            //当进入下一行时，y值会累加
            self.lastYValueForColumn[@(currentColumn)] = @(y);
            
            currentColumn++;
            if (currentColumn == self.numberofColumns)
            {
                currentColumn = 0;
            }
            
            self.layoutInfo[indexPath] = itemAttributes;
        }
    }
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *allAttributes = [NSMutableArray arrayWithCapacity:[self.layoutInfo count]];
    [self.layoutInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attributes, BOOL * _Nonnull stop) {
        if (CGRectIntersectsRect(rect, attributes.frame))
        {
            [allAttributes addObject:attributes];
        }
    }];
    
    return allAttributes;
}

- (CGSize)collectionViewContentSize
{
    NSUInteger currentColumn = 0;
    CGFloat maxHeight = 0;
    do
    {
        CGFloat height = [self.lastYValueForColumn[@(currentColumn)] doubleValue];
        if (height > maxHeight)
        {
            maxHeight = height;
        }
        
        currentColumn++;
    }while (currentColumn < self.numberofColumns);
    
    NSLog(@"maxHeight = %f", maxHeight);
    return CGSizeMake(self.collectionView.frame.size.width, maxHeight);
}

@end
