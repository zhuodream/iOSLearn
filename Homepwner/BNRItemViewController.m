//
//  ItemViewController.m
//  Homepwner
//
//  Created by 7road on 15/7/23.
//  Copyright (c) 2015年 7road. All rights reserved.
//

#import "BNRItemViewController.h"
#import "BNRItem.h"
#import "BNRItemStore.h"
#import "BNRItemCell.h"
#import "BNRImageStore.h"
#import "BNRImageViewController.h"

@interface BNRItemViewController () <UIPopoverControllerDelegate>

//@property (nonatomic,strong) IBOutlet UIView *headerView;
@property (nonatomic,strong) UIPopoverController *imagePopover;


@end

@implementation BNRItemViewController

-(instancetype)init
{
    self=[super initWithStyle:UITableViewStylePlain];
    if(self)
    {
        UINavigationItem *navItem=self.navigationItem;
        //navItem.title=@"Homepwner";
        navItem.title=NSLocalizedString(@"Homepwner", @"Name of application");
        
        //创建恢复标识
        self.restorationIdentifier=NSStringFromClass([self class]);
        self.restorationClass=[self class];
        
        //创建新的UIBarButtonItem对象
        //将其目标对象设置为当前对象，将其动作方法设置为adNewdItem:
        UIBarButtonItem *bbi=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
        
        //为UINavigationItem对象的rightBarButtonItem属性赋值
        //指向新建的UIBarButtonI tem对象
        navItem.rightBarButtonItem=bbi;
        
        navItem.leftBarButtonItem=self.editButtonItem;
        
        NSNotificationCenter *nc=[NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(UpdateTableViewForDynamicTypeSize) name:UIContentSizeCategoryDidChangeNotification object:nil];
        
        //注册当前区域设置发生变化的通知
        [nc addObserver:self selector:@selector(localeChanged:) name:NSCurrentLocaleDidChangeNotification object:nil];
    }
    return self;
}

- (void)localeChanged:(NSNotification *)note
{
    [self.tableView reloadData];
}

-(void)dealloc
{
    NSNotificationCenter *nc=[NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
}

//-(instancetype)initWithStyle:(UITableViewStyle)style
//{
//    return [self init];
//}



//BNRItemViewController遵守UITableViewDataSource协议，故需实现必需方法
//tableView方法返回每个表格段的行数，每个BNRItem对象占用一行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[BNRItemStore sharedStore] allItems] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    //创建UITableViewCell对象，风格使用默认的UITableViewCellStylDefault
//    UITableViewCell *cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];

    //创建或重用UITableViewCell对象
//    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];

    //获取BNRItemCell对象，返回的可能是现有的对象，也可能是新建的对象
    BNRItemCell *cell=[tableView dequeueReusableCellWithIdentifier:@"BNRItemCell" forIndexPath:indexPath];
    
    
    //获取allItems的第n个BNRItem对象
    //然后将BNRItem对象的描述信息赋给UITableViewCell对象的textLabel
    //这里的n是该UITableViewCell对象所对应的表格行索引
    NSArray *items=[[BNRItemStore sharedStore] allItems];
    BNRItem *item=items[indexPath.row];
    
//    cell.textLabel.text=[item description];
    
    //根据BNRItem对象设置BNRItemCell对象
    cell.nameLabel.text=item.itemName;
    cell.serialNumberLabel.text=item.serialNumber;
    static NSNumberFormatter *currencyFormatter=nil;
    //货币格式化
    if(currencyFormatter==nil)
    {
        currencyFormatter=[[NSNumberFormatter alloc] init];
        currencyFormatter.numberStyle=NSNumberFormatterCurrencyStyle;
    }
    cell.valueLabel.text=[currencyFormatter stringFromNumber:@(item.valueInDollars)];
    cell.thumbnailView.image=item.thumbnail;
    
   
    
    //将cell设置为弱引用
    __weak BNRItemCell *weakCell=cell;
    
    cell.actionBlock=^{NSLog(@"Going to show image for %@",item);
        BNRItemCell *strongcell=weakCell;
        if([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad)
        {
            NSString *itemKey=item.itemKey;
            
            //如果BNRItem对象没有图片，就直接返回
            UIImage *img=[[BNRImageStore sharedStore] imageForKey:itemKey];
            if(!img)
            {
                return;
            }
            
            //根据UITableView对象的坐标系获取UIImageView对象的位置和大小
            //注意：这里也许会出现警告信息，下面很快就会讨论到
            CGRect rect=[self.view convertRect:strongcell.thumbnailView.bounds
                                     fromView:strongcell.thumbnailView];
            
            //创建BNRItemViewController对象并为image属性赋值
            BNRImageViewController *ivc=[[BNRImageViewController alloc]init];
            ivc.image=img;
            
            //根据UITableView对象的位置和大小，显示一个大小为600*600点的UIPopoverController对象
            self.imagePopover=[[UIPopoverController alloc] initWithContentViewController:ivc];
            self.imagePopover.popoverContentSize=CGSizeMake(600, 600);
            [self.imagePopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    
    
    };
    
    return cell;
}


-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.imagePopover=nil;
}

-(void) viewDidLoad
{
    [super viewDidLoad];
    
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];

    //创建UINib对象，该对象代表包含了BNRItemCell的NIB文件
    UINib *nib=[UINib nibWithNibName:@"BNRItemCell" bundle:nil];
    
    //通过UINib对象注册相应的NIB文件
    [self.tableView registerNib:nib forCellReuseIdentifier:@"BNRItemCell"];
    
//    UIView *header=self.headerView;
//    [self.tableView setTableHeaderView:header];
}

//-(UIView *)headerView
//{
//    //如果还没有载入headerView
//    if(!_headerView)
//    {
//        [[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:self options:nil];
//    }
//    
//    return _headerView;
//}
//添加新对象
-(IBAction)addNewItem:(id)sender
{
    
    //创建新的BNRItem对象，并加入BNRItemStore对象中
    BNRItem *newItem=[[BNRItemStore sharedStore] createItem];
//    //获取新创建的对象在allItems数组中的索引
//    NSInteger lastRow=[[[BNRItemStore sharedStore] allItems] indexOfObject:newItem];
//    
//    
//    //创建NSIndexPath对象，代表的位置是:第一个表格段,最后一个表格行
//    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:lastRow inSection:0];
//    
//    //将新行插入UITableView对象
//    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    
    BNRDetailViewController *detailViewController=[[BNRDetailViewController alloc] initForNewItem:YES];
    detailViewController.item=newItem;
    
    detailViewController.dismissBlock=^{[self.tableView reloadData];};
    
    UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:detailViewController];
    navController.restorationIdentifier=NSStringFromClass([navController class]);
    //设置以模态形式显示的视图控制器UINavigationController对象为表单样式
    navController.modalPresentationStyle=UIModalPresentationFormSheet;
    
    [self presentViewController:navController animated:YES completion:nil];
}


////编辑模式的开关
//-(IBAction)toggleEditingMode:(id)sender
//{
//    if(self.isEditing)
//    {
//        //修改按钮文字
//        [sender setTitle:@"Edit" forState:UIControlStateNormal];
//        
//        //关闭编辑模式
//        [self setEditing:NO animated:YES];
//    }
//    else
//    {
//        [self setEditing:YES animated:YES];
//        [sender setTitle:@"Done" forState:UIControlStateNormal];
//    }
//}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //如果请求的是删除操作
    if(editingStyle==UITableViewCellEditingStyleDelete)
    {
        NSArray *items=[[BNRItemStore sharedStore] allItems];
        BNRItem *item=items[indexPath.row];
        [[BNRItemStore sharedStore] removeItem:item];
        
        //还要删除表格视图中的相应表格行,带动画效果
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void)tableView:(UITableView *)tableView
    moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[BNRItemStore sharedStore] moveItemAtIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
}

//更改删除按钮的标题为remove
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Remove";
}

//确定indexPath.row是否可编辑
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL isEditable=YES;
    NSUInteger count=[[[BNRItemStore sharedStore] allItems] count];
    
    if(indexPath.row==count)
    {
        isEditable=NO;
    }
    
    return isEditable;
}

-(NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    NSArray *items=[[BNRItemStore sharedStore] allItems];
    
    NSInteger maxRow=items.count;
    
    if(proposedDestinationIndexPath.row==maxRow)
    {
        NSLog(@"This  %ld is not allowed",(long)proposedDestinationIndexPath.row);
        return sourceIndexPath;
    }
    
    return proposedDestinationIndexPath;
}

//用户点击UITableView对象中的某个表格行时，该对象会向其委托对象发送tableView:didSelectRowAtIndexPath:消息
//并传入选中的行的索引信息
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    //创建BNRDetailViewController对象
//    BNRDetailViewController *detailViewController=[[BNRDetailViewController alloc] init];

    BNRDetailViewController *detailViewController=[[BNRDetailViewController alloc] initForNewItem:NO];
    
    //将选中的 BNRItem对象传给BNRDetailViewController
    NSArray *items=[[BNRItemStore sharedStore] allItems];
    BNRItem *selectedItem=items[indexPath.row];
    
    detailViewController.item=selectedItem;
    
    //将新创建的对象压入UINavigationController对象的栈
    [self.navigationController pushViewController:detailViewController animated:YES];
}



//当BNRItemViewController再次出现在屏幕上时，应该刷新数据
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //[self.tableView reloadData];
    [self UpdateTableViewForDynamicTypeSize];
}

-(void)UpdateTableViewForDynamicTypeSize
{
    static NSDictionary *cellHeightDictionary;
    
    if(!cellHeightDictionary)
    {
        cellHeightDictionary=@{
            UIContentSizeCategoryExtraSmall:@44,
            UIContentSizeCategorySmall:@44,
            UIContentSizeCategoryMedium:@44,
            UIContentSizeCategoryLarge:@44,
            UIContentSizeCategoryExtraLarge:@55,
            UIContentSizeCategoryExtraExtraLarge:@65,
            UIContentSizeCategoryExtraExtraExtraLarge:@75
            };
    }
    
    NSString *userSize=[[UIApplication sharedApplication] preferredContentSizeCategory];
    
    NSNumber *cellheight=cellHeightDictionary[userSize];
    [self.tableView setRowHeight:cellheight.floatValue];
    [self.tableView reloadData];
}


+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    return [[self alloc] init];
}

@end
