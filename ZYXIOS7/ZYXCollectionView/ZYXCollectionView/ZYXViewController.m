//
//  ViewController.m
//  ZYXCollectionView
//
//  Created by 7road on 15/10/9.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "ZYXViewController.h"
#import "ZYXPhotoCell.h"
#import "ZYXDetailViewController.h"


enum PhotoOrientation
{
    PhotoOrientationLandscape,
    PhtotOrientationPortrait
};

@interface ZYXViewController ()

@property (nonatomic, strong) NSArray *photosList;
@property (nonatomic, strong) NSMutableArray *photoOrientation;
@property (nonatomic, strong) NSMutableDictionary *photosCache;

@end

@implementation ZYXViewController

- (NSString *)photoDirectory
{
    return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Photos"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSArray *photosArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self photoDirectory] error:nil];
    self.photosCache = [NSMutableDictionary dictionary];
    self.photoOrientation = [NSMutableArray array];
    self.photosList = nil;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [photosArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *path = [[self photoDirectory] stringByAppendingPathComponent:obj];
            CGSize size = [UIImage imageWithContentsOfFile:path].size;
            if (size.width > size.height)
            {
                [self.photoOrientation addObject:[NSNumber numberWithInt:PhotoOrientationLandscape]];
            }
            else
                [self.photoOrientation addObject:[NSNumber numberWithInt:PhtotOrientationPortrait]];
        }];
       
        dispatch_async(dispatch_get_main_queue(), ^{
            self.photosList = photosArray;
            [self.collectionView reloadData];
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.photosList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifierLandscape = @"ZYXPhotoCellLandscape";
    static NSString *CellIdentifierPortrait = @"ZYXPhotoCellPortrait";
    int orientation = [[self.photoOrientation objectAtIndex:indexPath.row] intValue];
    ZYXPhotoCell *cell = (ZYXPhotoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:
                            orientation == PhotoOrientationLandscape ?CellIdentifierLandscape:CellIdentifierPortrait forIndexPath:indexPath];
    
    NSString *photoName = [self.photosList objectAtIndex:indexPath.row];
    NSString *photoFilePath = [[self photoDirectory] stringByAppendingPathComponent:photoName];
    cell.lable.text = [photoName stringByDeletingPathExtension];
    
    __block UIImage *thumbImage = [self.photosCache objectForKey:photoName];
    cell.imageView.image = thumbImage;
    
    if (!thumbImage)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            UIImage *image = [UIImage imageWithContentsOfFile:photoFilePath];
            if (orientation == PhtotOrientationPortrait)
            {
                UIGraphicsBeginImageContext(CGSizeMake(180.0f, 120.0f));
                [image drawInRect:CGRectMake(0, 0, 180.0f, 120.0f)];
                thumbImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            }
            else
            {
                UIGraphicsBeginImageContext(CGSizeMake(120.0f, 180.0f));
                [image drawInRect:CGRectMake(0, 0, 120.0f, 180.0f)];
                thumbImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.photosCache setObject:thumbImage forKey:photoName];
                cell.imageView.image = thumbImage;
            });
        });
        
    }
    
    return  cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"MainSegue" sender:indexPath];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *selectedIndexPath = sender;
    NSString *photoName = [self.photosList objectAtIndex:selectedIndexPath.row];
    
    ZYXDetailViewController *controller = segue.destinationViewController;
    controller.photoPath = [[self photoDirectory] stringByAppendingPathComponent:photoName];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    static NSString * SupplementaryViewIndentifier = @"SupplementaryViewIdentifier";
    
    return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:SupplementaryViewIndentifier forIndexPath:indexPath];
}


@end
