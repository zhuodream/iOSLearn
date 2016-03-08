//
//  ViewController.m
//  ZYXCoreData
//
//  Created by 7road on 16/2/2.
//  Copyright © 2016年 zhuo. All rights reserved.
//

#import "ViewController.h"
#import <CoreData/CoreData.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //加载模型文件
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    //传入模型对象，初始化NSPersistentStoreCoordinator
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    //构建SQLite数据库文件的路径
    NSString *docs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSURL *url = [NSURL fileURLWithPath:[docs stringByAppendingPathComponent:@"person.data"]];
    NSLog(@"URL = %@", url);
    //添加持久化存储库，这里使用SQLite作为存储库
    NSError *error = nil;
    NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
    if (store == nil)
    {
        [NSException raise:@"添加数据库异常" format:@"%@", [error localizedDescription]];
    }
    
    //初始化上下文，设置persistentStoreCoordinator属性
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    context.persistentStoreCoordinator = psc;
    
    NSManagedObject *person = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:context];
    //设置person的简单属性
    [person setValue:@"MJ" forKey:@"name"];
    [person setValue:[NSNumber numberWithInt:27] forKey:@"age"];
    
    //传入上下文，创建一个Card对象
    NSManagedObject *card = [NSEntityDescription insertNewObjectForEntityForName:@"Card" inManagedObjectContext:context];
    [card setValue:@"4414241933432" forKey:@"no"];
    //设置person与card的关联关系
    [person setValue:card forKey:@"card"];
    //利用上下文对象，将数据同步到持久化存储库
    NSError *err = nil;
    BOOL success = [context save:&err];
    if (!success)
    {
        [NSException raise:@"访问数据库错误" format:@"%@", [err localizedDescription]];
    }
    
    //查询对象
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    //设置要查询的实体
    request.entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:context];
    //设置排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"age" ascending:NO];
    request.sortDescriptors = [NSArray arrayWithObject:sort];
    //设置条件过滤（搜索name中包含字符串"Itcast-1"的记录，注意：设置条件过滤时，数据库中的SQL语句中的%要用*来代替,所以%Itcast-1%应该携程*Itcast-1*）
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name like %@", @"M*"];
    request.predicate = predicate;
    
    //执行请求
    NSError *err2 = nil;
    NSArray *objs = [context executeFetchRequest:request error:&err2];
    if (err2)
    {
        [NSException raise:@"查询错误" format:@"%@", err2.localizedDescription];
    }
    NSLog(@"objs count = %ld", objs.count);
    NSLog(@"objs ==== %@", objs);
    //遍历数据
    for (NSManagedObject *obj in objs)
    {
        NSLog(@"name ==== %@", [obj valueForKey:@"name"]);
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
