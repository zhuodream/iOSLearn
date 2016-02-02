//
//  ZYXCoverFlowLayout.m
//  ZYXCoverFlowLayout
//
//  Created by 7road on 15/10/10.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "ZYXCellCoverFlowLayout.h"

@implementation ZYXCellCoverFlowLayout

#define ZOOM_FACTOR 0.35

- (void)prepareLayout
{
    //设置滚动方向
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    CGSize size = self.collectionView.frame.size;
    //设置cell的大小
    self.itemSize = CGSizeMake(size.width/4.0f, size.height*0.7);
    //设置上下左右的间距
    self.sectionInset = UIEdgeInsetsMake(size.height * 0.15, size.height * 0.1, size.height * 0.1, size.height * 0.1);
}

//设置新的区域是否需要布局更新
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    float collentionViewHalfFrame = self.collectionView.frame.size.width/2.0f;
    NSLog(@"halfframe = %f", collentionViewHalfFrame);
    for (UICollectionViewLayoutAttributes *attributes in array)
    {
        if (CGRectIntersectsRect(attributes.frame, rect))
        {
            CGFloat distance = CGRectGetMidX(visibleRect) - attributes.center.x;
            NSLog(@"mid = %f",CGRectGetMidX(visibleRect));
            NSLog(@"distance = %f", distance);
            NSLog(@"attributes.center.x = %f", attributes.center.x);
            CGFloat normalizedDitance = distance / collentionViewHalfFrame;
            NSLog(@"normal = %f", normalizedDitance);
            if (ABS(distance) < collentionViewHalfFrame)
            {
                CGFloat zoom = 1 + ZOOM_FACTOR * (1 - ABS(normalizedDitance));
                CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
                //m34透视效果，近大远小
                rotationAndPerspectiveTransform.m34 = 1.0 / -500;
                rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, (normalizedDitance) * M_PI_4, 0.0f, 1.0f, 0.0f);
                CATransform3D zoomTransform = CATransform3DMakeScale(zoom, zoom, 1.0);
                attributes.transform3D = CATransform3DConcat(zoomTransform, rotationAndPerspectiveTransform);
                attributes.zIndex = ABS(normalizedDitance) * 10.0f;
                
                CGFloat alpha = (1 - ABS(normalizedDitance)) + 0.1;
                if (alpha > 1.0f)
                {
                    alpha = 1.0f;
                }
                attributes.alpha = alpha;
            }
            else
            {
                attributes.alpha = 0.0f;
            }
        }
    }
    
    return array;
}

@end
