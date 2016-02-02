//
//  ViewController.m
//  ZYXCollectionLayout
//
//  Created by 7road on 15/10/9.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "ZYXCollectionViewController.h"
#import "ZYXCollectionViewCell.h"

@interface ZYXCollectionViewController ()

@end

@implementation ZYXCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 100;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZYXCollectionViewCell * cell = (ZYXCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"ZYXCell" forIndexPath:indexPath];
    
    return cell;
}

//流式布局委托方法改变物件大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat randomHeight = 100 + (arc4random() % 140);
    return CGSizeMake(100, randomHeight);
}

// this will be called if our layout is MKMasonryViewLayout
- (CGFloat) collectionView:(UICollectionView*) collectionView
                    layout:(ZYXMasonryViewLayout*) layout
  heightForItemAtIndexPath:(NSIndexPath*) indexPath {
    
    // we will use a random height from 100 - 400
    
    CGFloat randomHeight = 100 + (arc4random() % 140);
    return randomHeight;
}

@end
