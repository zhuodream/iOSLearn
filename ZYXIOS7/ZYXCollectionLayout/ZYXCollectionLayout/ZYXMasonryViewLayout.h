//
//  ZYXMasonryViewLayout.h
//  ZYXCollectionLayout
//
//  Created by 7road on 15/10/9.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZYXMasonryViewLayout;

@protocol ZYXMasonryViewLayoutDelegate <NSObject>

@required
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(ZYXMasonryViewLayout *)layout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface ZYXMasonryViewLayout : UICollectionViewLayout

@property (nonatomic, assign) NSUInteger numberofColumns;
@property (nonatomic, assign) CGFloat interItemSpacing;
@property (nonatomic, weak) id<ZYXMasonryViewLayoutDelegate> delegate;
@end
