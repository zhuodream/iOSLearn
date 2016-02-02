//
//  BNRDetailViewController.m
//  Homepwner
//
//  Created by 7road on 15/7/24.
//  Copyright (c) 2015年 7road. All rights reserved.
//

#import "BNRDetailViewController.h"
#import "BNRItem.h"
#import "BNRImageStore.h"
#import "BNRItemStore.h"
#import "BNRAssetTypeViewController.h"
#import "AppDelegate.h"

@interface BNRDetailViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,UIPopoverControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *serialNumberField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraButton;
@property (strong,nonatomic)UIPopoverController *imagePickerPopover;

@property (weak,nonatomic) IBOutlet UILabel *nameLabel;
@property (weak,nonatomic) IBOutlet UILabel *serialNumberLabel;
@property (weak,nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *assetTypeButton;

@end

@implementation BNRDetailViewController


-(void)save:(id)sender
{
    //当某个UIVierController对象以模态形式显示时，presentingViewController会指向显示该对象的那个UIViewController对象，这里即BNRItemViewController
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

- (IBAction)showAssetTypePicker:(id)sender
{
    [self.view endEditing:YES];
    
    BNRAssetTypeViewController *avc=[[BNRAssetTypeViewController alloc] init];
    avc.item=self.item;
    
    [self.navigationController pushViewController:avc animated:YES];
}

-(void)cancel:(id)sender
{
    //如果用户按下了Cancel按钮,就从BNRItemStore对象移除新创建的BNRItem对象
    [[BNRItemStore sharedStore] removeItem:self.item];
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

-(instancetype)initForNewItem:(BOOL)isNew
{
    self=[super initWithNibName:nil bundle:nil];
    
    if(self)
    {
        //设置恢复标识和恢复类，恢复类用来在恢复对象状态时创建该对象
        self.restorationIdentifier=NSStringFromClass([self class]);
        self.restorationClass=[self class];
        if(isNew)
        {
            UIBarButtonItem *doneItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save:)];
            self.navigationItem.rightBarButtonItem=doneItem;
            
            UIBarButtonItem *cancelItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
            self.navigationItem.leftBarButtonItem=cancelItem;
        }
        
        NSNotificationCenter *defaultCenter=[NSNotificationCenter defaultCenter];
        [defaultCenter addObserver:self selector:@selector(updateFonts) name:UIContentSizeCategoryDidChangeNotification object:nil];
        
    }
    return self;
}

-(void)dealloc
{
    NSNotificationCenter *defaultCenter=[NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self];
}
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    @throw [NSException exceptionWithName:@"Wrong initializer" reason:@"Use initForNewItem" userInfo:nil];
    
    return nil;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *iv=[[UIImageView alloc] initWithImage:nil];
    
    //设置UIImageView对象的内容缩放模式,
    iv.contentMode=UIViewContentModeScaleAspectFill;
    
    //告诉自动布局系统不要将自动缩放掩码转换为约束
    iv.translatesAutoresizingMaskIntoConstraints=NO;
    //不希望超过frame的区域显示在屏幕上要设置
    iv.clipsToBounds  = YES;
    //将UIImageView对象添加到view上
    [self.view addSubview:iv];
    
    //将UIImageView对象赋给imageView属性
    self.imageView=iv;
    
//    //将imageView垂直方向的优先级设置为比其他视图低的数值
//    [self.imageView setContentHuggingPriority:200 forAxis:UILayoutConstraintAxisVertical];
//    [self.imageView setContentCompressionResistancePriority:700 forAxis:UILayoutConstraintAxisVertical];
    
    
    //创建视图名称字典
    NSDictionary *nameMap=@{@"imageView":self.imageView,
                            @"dateLabel":self.dateLabel,
                            @"toolbar":self.toolbar};
    
    //imageView的左边和右边与父视图的距离都是0点
    NSArray *horizontalConstraints=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView]-0-|" options:0 metrics:nil views:nameMap];
    
    //imageView的顶边与dateLabel的距离是8点，底边与toolbar的距离也是8点
    NSArray *verticalConstraints=[NSLayoutConstraint constraintsWithVisualFormat:@"V:[dateLabel]-[imageView]-[toolbar]" options:0 metrics:nil views:nameMap];
    
    [self.view addConstraints:verticalConstraints];
    [self.view addConstraints:horizontalConstraints];
    
   
    
}

-(void)updateFonts
{
    UIFont *font=[UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
    self.nameLabel.font=font;
    self.serialNumberLabel.font=font;
    self.valueLabel.font=font;
    self.dateLabel.font=font;
    
    self.nameField.font=font;
    self.serialNumberField.font=font;
    self.valueField.font=font;
}

////检查UIView是否存在有歧义的布局
//-(void)viewDidLayoutSubviews
//{
//    for (UIView *subView in self.view.subviews) {
//        if([subView hasAmbiguousLayout])
//        {
//            NSLog(@"AMBIGUOUS: %@",subView);
//        }
//    }
//}

- (IBAction)backgroundTapped:(id)sender {
    [self.view endEditing:YES];
    
//    for (UIView *subView in self.view.subviews) {
//        if([subView hasAmbiguousLayout])
//        {
//            [subView exerciseAmbiguityInLayout];
//        }
//    }
}

- (IBAction)takePicture:(id)sender
{
    
    //如果再次按下拍照按钮，应先确认上一个UIPopverController对象是否存在,存在则关闭
    if([self.imagePickerPopover isPopoverVisible])
    {
        [self.imagePickerPopover dismissPopoverAnimated:YES];
        self.imagePickerPopover=nil;
        return;
    }
    
    
    UIImagePickerController *imagePicker=[[UIImagePickerController alloc] init];
    
    //如果设备支持相机，就使用拍照模式
    //否则让用户从照片库中选择
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
    }
    else
    {
        imagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    }
    imagePicker.delegate=self;
    
//    //以模态的形式显示UIImagePickerController对象
//    [self presentViewController:imagePicker animated:YES completion:nil];
    //显示UIImagePickerController对象
    //创建UIPopoverController对象前先检查当前设备是否是ipad
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad)
    {
        //创建UIPopoverController对象，用于显示UIImagePickerController对象
        self.imagePickerPopover=[[UIPopoverController alloc] initWithContentViewController:imagePicker];
        self.imagePickerPopover.delegate=self;
        
        //显示UIPopoverController对象
        //sender指向的事代表相机按钮的UIBarButtonItem对象
        [self.imagePickerPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    else
    {
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIInterfaceOrientation io=[[UIApplication sharedApplication] statusBarOrientation];
    [self prepareViewsForOrientation:io];
    
    BNRItem *item=self.item;
    
    self.nameField.text=item.itemName;
    self.serialNumberField.text=item.serialNumber;
    self.valueField.text=[NSString stringWithFormat:@"%d",item.valueInDollars];

    
    //创建NSDateFormatter对象，用于将NSDate对象转换成简单的日期字符串
    static NSDateFormatter *dateFormatter=nil;
    if(!dateFormatter)
    {
        dateFormatter=[[NSDateFormatter alloc] init];
        dateFormatter.dateStyle=NSDateIntervalFormatterMediumStyle;
        dateFormatter.timeStyle=NSDateFormatterNoStyle;
    }
    
    //将转换后得到的日期字符串设置为dateLabel的标题
    self.dateLabel.text=[dateFormatter stringFromDate:item.dateCreated];
    
    NSString *itemKey=self.item.itemKey;
    if(itemKey)
    {
        //根据itemKey从BNRImageStore对象获取照片
        UIImage *imageToDisplay=[[BNRImageStore sharedStore] imageForKey:itemKey];
        self.imageView.image=imageToDisplay;
    }
    else
    {
        self.imageView.image=nil;
    }
    
    NSString *typeLabel=[self.item.assetType valueForKey:@"label"];
    if(!typeLabel)
    {
        //typeLabel=@"None";
        typeLabel=NSLocalizedString(@"None", @"Type label None");
    }
    
    //self.assetTypeButton.title=[NSString stringWithFormat:@"Type: %@",typeLabel];
    self.assetTypeButton.title=[NSString stringWithFormat:NSLocalizedString(@"Type: %@", @"Asset type button"),typeLabel];
    
    [self updateFonts];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //取消当前的第一响应对象
    [self.view endEditing:YES];
    
    BNRItem *item=self.item;
    item.itemName=self.nameField.text;
    item.serialNumber=self.serialNumberField.text;
    
    int newValue=[self.valueField.text intValue];
    //比较valueIndollars属性与valueField中的新值，判断是否有改动
    if (newValue!=item.valueInDollars)
    {
        //如果有改动，将新值赋给valueIndollars属性
        item.valueInDollars=newValue;
        
        //将新值存入NSUserDefaults
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        [defaults setInteger:newValue forKey:BNRNextItemValuePrefsKey];
    }
   // item.valueInDollars=[self.valueField.text intValue];
}

-(void) setItem:(BNRItem *)item
{
    _item=item;
    self.navigationItem.title=_item.itemName;
}

//实现选取照片后的委托方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //通过info字典获取选择的照片
    UIImage *image=info[UIImagePickerControllerOriginalImage];
    
    [self.item setThumbnailFromImage:image];
    
    //以itemKey为键，将照片存入BNRImageStore对象
    [[BNRImageStore sharedStore] setImage:image forKey:self.item.itemKey];
    
    //将照片放入UIImageView 对象
    self.imageView.image=image;
    
    
//    //关闭UIImagePickerController对象
//    [self dismissViewControllerAnimated:YES completion:nil];

    //判断UIPopverController对象是否存在
    if(self.imagePickerPopover)
    {
        //关闭UIPopverController对象
        [self.imagePickerPopover dismissPopoverAnimated:YES];
        self.imagePickerPopover=nil;
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    //放弃第一响应
    [textField resignFirstResponder];
    return YES;
}

-(void)prepareViewsForOrientation:(UIInterfaceOrientation)orientation
{
    //如果是ipad，则不执行任何操作
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad)
    {
        return;
    }
    
    //判断设备是否处于横排方向
    if(UIInterfaceOrientationIsLandscape(orientation))
    {
        self.imageView.hidden=YES;
        self.cameraButton.enabled=NO;
    }
    else
    {
        self.imageView.hidden=NO;
        self.cameraButton.enabled=YES;
    }
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self prepareViewsForOrientation:toInterfaceOrientation];
}


-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    NSLog(@"User dismissed popver");
    self.imagePickerPopover=nil;
}

+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    BOOL isNew=NO;
    if([identifierComponents count]==3)
    {
        isNew=YES;
    }
    
    return [[self alloc] initForNewItem:isNew];
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.item.itemKey forKey:@"item.itemKey"];
    //保存UITextField对象中的文本
    self.item.itemName=self.nameField.text;
    self.item.serialNumber=self.serialNumberField.text;
    self.item.valueInDollars=[self.valueField.text intValue];
    
    //保存修改
    [[BNRItemStore sharedStore] saveChanges];
    
    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    NSString *itemKey=[coder decodeObjectForKey:@"item.itemKey"];
    
    for(BNRItem * item in [[BNRItemStore sharedStore] allItems])
    {
        if([itemKey isEqualToString:item.itemKey])
        {
            self.item=item;
            break;
        }
    }
    
    [super decodeRestorableStateWithCoder:coder];
}


@end
