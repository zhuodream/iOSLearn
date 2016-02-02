//
//  BNRItemStore.m
//  Homepwner
//
//  Created by 7road on 15/7/23.
//  Copyright (c) 2015年 7road. All rights reserved.
//

#import "BNRItemStore.h"
#import "BNRItem.h"
#import "BNRImageStore.h"
#import "Homepwner/AppDelegate.h"

@import CoreData;

@interface BNRItemStore ()

@property (nonatomic) NSMutableArray *privateItems;
@property (nonatomic,strong) NSMutableArray *allAssetTypes;
@property (nonatomic,strong) NSManagedObjectContext *context;
@property (nonatomic,strong) NSManagedObjectModel *model;

@end

@implementation BNRItemStore

+(instancetype)sharedStore
{
    static BNRItemStore *sharedStore=nil;
//    if(!sharedStore)
//    {
//        sharedStore=[[self alloc] initPrivate];
//    }
    //多线程中创建安全的单例
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        sharedStore=[[self alloc]initPrivate];
    });
    return sharedStore;
}

//如果调用[[BNRItemStore alloc]init],就提示应该使用[BNRItemStore sharedStore];
-(instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use+[BNRItemStore sharedStore]" userInfo:nil];
    
    return nil;
}


-(instancetype)initPrivate
{
    self=[super init];
    if(self)
    {
//        //_privateItems=[[NSMutableArray alloc] init];
//        
//        NSString *path=[self itemArchivePath];
//        _privateItems=[NSKeyedUnarchiver unarchiveObjectWithFile:path];
//        
//        //如果之前没有保存数据，会创建一个新的
//        if(!_privateItems)
//        {
//            _privateItems=[[NSMutableArray alloc]init];
//        }
//        
//        //在最后添加‘no more items!‘标签
//        //[self.privateItems addObject:@"No more items!"];
        
        //读取Homepwner.xcdatamodeld
        _model=[NSManagedObjectModel mergedModelFromBundles:nil];
        
        NSPersistentStoreCoordinator *psc=[[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
        
        //设置SQLite文件路径
        NSString *path=self.itemArchivePath;
        NSURL *storeURL=[NSURL fileURLWithPath:path];
        
        NSError *error=nil;
        
        if(![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
        {
            @throw [NSException exceptionWithName:@"OpenFailure" reason:[error localizedDescription] userInfo:nil];
        }
        
        //创建NSManagedObjectContext对象
        _context=[[NSManagedObjectContext alloc]init];
        _context.persistentStoreCoordinator=psc;
        
        [self loadAllItems];
    }
    return self;
}

-(NSArray *)allItems
{
    return self.privateItems;
}

-(BNRItem *)createItem
{
    //BNRItem *item=[BNRItem randomItem];
    
//    BNRItem *item=[[BNRItem alloc]init];
    double order;
    if([self.allItems count]==0)
    {
        order=1.0;
    }
    else
    {
        order=[[self.privateItems lastObject] orderingValue]+1.0;
    }
    NSLog(@"Adding after %lu items,order=%.2f",(unsigned long)[self.privateItems count],order);
    BNRItem *item=[NSEntityDescription insertNewObjectForEntityForName:@"BNRItem" inManagedObjectContext:self.context];
    item.orderingValue=order;
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    item.valueInDollars=[defaults integerForKey:BNRNextItemValuePrefsKey];
    item.itemName=[defaults objectForKey:BNRNextItemNamePrefsKey];
    
    //查看UserDefaults中存储了哪些数据
    NSLog(@"defaults=%@",[defaults dictionaryRepresentation]);
    
    [self.privateItems addObject:item];
    
    return item;
}

-(void)removeItem:(BNRItem *)item
{
    NSString *key=item.itemKey;
    
    [[BNRImageStore sharedStore] deleteImageForKey:key];
    
    [self.context deleteObject:item];
    [self.privateItems removeObjectIdenticalTo:item];
}

-(void)moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
    if(fromIndex==toIndex)
    {
        return;
    }
    
    BNRItem *item=self.privateItems[fromIndex];
    
    //将item从allItems数组中移除
    [self.privateItems removeObjectAtIndex:fromIndex];
    
    //根据新的索引，将item插回allItems数组
    [self.privateItems insertObject:item atIndex:toIndex];
    
    //为移动的BNRItem对象计算新的orderValue
    double lowerBound=0.0;
    
    //在数组中，该对象之前是否有其他对象
    if(toIndex>0)
    {
        lowerBound=[self.privateItems[(toIndex-1)] orderingValue];
    }
    else
    {
        lowerBound=[self.privateItems[1] orderingValue]-2.0;
    }
    
    double upperBound=0.0;
    
    //在数组中，该对象之后c是否有其他对象
    if(toIndex<[self.privateItems count]-1)
    {
        upperBound=[self.privateItems[(toIndex+1)]orderingValue];
    }
}

//设置保存文件的路径
-(NSString *)itemArchivePath
{
    //注意第一个参数是NSDocumentDirectory而不是NSDocumentationDirectory
    //NSSearchPathForDirectoriesInDomains是一个c函数，得到沙盒中某种目录的全路径，返回的是一个数组，因为mac os x中可能包含很多相同名字的目录，但在ios应用中就只有一个目录
    NSArray *documentDirectories=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //从documentDirectories数组获取第一个，也是唯一文档目录路径
    NSString *documentDirectory=[documentDirectories firstObject];
    
   // return [documentDirectory stringByAppendingPathComponent:@"items.archive"];
    return [documentDirectory stringByAppendingPathComponent:@"store.data"];
}

//保存数据
-(BOOL)saveChanges
{
//    //获取路径
//    NSString *path=[self itemArchivePath];
//    NSLog(@"%@",path);
//    //如果固化成功就返回yes
//    return [NSKeyedArchiver archiveRootObject:self.privateItems toFile:path];

    NSError *error;
    BOOL successful=[self.context save:&error];
    if(!successful)
    {
        NSLog(@"Error saving: %@",[error localizedDescription]);
    }
    return successful;
}

-(void)loadAllItems
{
    if(!self.privateItems)
    {
        NSFetchRequest *request=[[NSFetchRequest alloc]init];
        
        NSEntityDescription *e=[NSEntityDescription entityForName:@"BNRItem" inManagedObjectContext:self.context];
        
        request.entity=e;
        
        NSSortDescriptor *sd=[NSSortDescriptor sortDescriptorWithKey:@"orderingValue" ascending:YES];
        request.sortDescriptors=@[sd];
        
        NSError *error;
        NSArray *result=[self.context executeFetchRequest:request error:&error];
        
        if(!result)
        {
            [NSException raise:@"Fecth failed" format:@"Reason:%@",[error localizedDescription]];
        }
        
        self.privateItems=[[NSMutableArray alloc]initWithArray:result];
    }
}

- (NSArray *) allAssetTypes
{
    if(!_allAssetTypes)
    {
        NSFetchRequest *request=[[NSFetchRequest alloc] init];
        
        NSEntityDescription *e=[NSEntityDescription entityForName:@"BNRAssetType" inManagedObjectContext:self.context];
        request.entity=e;
        
        NSError *error=nil;
        NSArray *result=[self.context executeFetchRequest:request error:&error];
        if(!result)
        {
            [NSException raise:@"Fetch failed" format:@"Resaon: %@",[error localizedDescription]];
        }
        
        _allAssetTypes=[result mutableCopy];
    }
    
    //第一次运行
    if ([_allAssetTypes count]==0) {
        NSManagedObject *type;
        type=[NSEntityDescription insertNewObjectForEntityForName:@"BNRAssetType" inManagedObjectContext:self.context];
        [type setValue:@"Furniture" forKey:@"label"];
        [_allAssetTypes addObject:type];
        
        type=[NSEntityDescription insertNewObjectForEntityForName:@"BNRAssetType" inManagedObjectContext:self.context];
        [type setValue:@"Jewelry" forKey:@"label"];
        [_allAssetTypes addObject:type];
        
        type=[NSEntityDescription insertNewObjectForEntityForName:@"BNRAssetType" inManagedObjectContext:self.context];
        [type setValue:@"Electronics" forKey:@"label"];
        [_allAssetTypes addObject:type];
    }
    
    return _allAssetTypes;
}

@end
