//
//  ViewController.m
//  ZYXCoverFlowLayout
//
//  Created by 7road on 15/10/10.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "ZYXViewController.h"
#import "ZYXCollectionCell.h"
#import "ZYXCellCoverFlowLayout.h"

@interface ZYXViewController ()

@property (strong, nonatomic) NSArray *photosList;
@property (strong, nonatomic) NSCache *photosCache;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

@end

@implementation ZYXViewController

-(NSString*) photosDirectory {
    
    return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Photos"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.photosList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self photosDirectory] error:nil];
    self.collectionView.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.photosList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
    cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ZYXCell";
    ZYXCollectionCell *cell = (ZYXCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSString *photoName = self.photosList[indexPath.row];
    NSString *photoFilePath = [[self photosDirectory] stringByAppendingPathComponent:photoName];
    
    __block UIImage * thumbImage = [self.photosCache objectForKey:photoName];
    cell.photoView.image = thumbImage;
    ZYXCellCoverFlowLayout *layout = (ZYXCellCoverFlowLayout *)collectionView.collectionViewLayout;
    
    if(!thumbImage) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            
            UIImage *image = [UIImage imageWithContentsOfFile:photoFilePath];
            float scale = [UIScreen mainScreen].scale;
            UIGraphicsBeginImageContextWithOptions(layout.itemSize, YES, scale);
            [image drawInRect:CGRectMake(0, 0, layout.itemSize.width, layout.itemSize.height)];
            thumbImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.photosCache setObject:thumbImage forKey:photoName];
                cell.photoView.image = thumbImage;
            });
        });
    }
    
    return cell;
    
}

@end
