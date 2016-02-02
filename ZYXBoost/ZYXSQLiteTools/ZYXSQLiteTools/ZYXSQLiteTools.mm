//
//  ZYXSQLiteTools.m
//  ZYXSQLiteTools
//
//  Created by 卓酉鑫 on 15/9/24.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "ZYXSQLiteTools.h"
/**
 nil：指向一个对象的空指针
 Nil：指向一个类的空指针
 NULL：指向其他类型（如：基本类型、C类型）的空指针
 NSNull：通常表示集合中的空值
 
 NSURL *url = nil;
 Class class = Nil;
 int *pointerInt = NULL;
 NSArray *array = [NSArray arrayWithObjects:[[NSObject alloc] init], [NSNull null], [[NSObject alloc] init], [[NSObject alloc] init], nil];
 
 如果用nil，就会变成NSArray *array = [NSArray arrayWithObjects:[[NSObject alloc] init], nil,  [[NSObject alloc] init], [[NSObject alloc] init], nil];，那么数组到第二个位置就会结束。打印[array count]的话会显示1而不是4
 所以[NSNull null]通常可以作为一个数组的占位符，从而是数组的count计算准确

 **/

@implementation ZYXSQLiteTools

+ (instancetype)getInstance
{
    static ZYXSQLiteTools *instance = nil;
    //one case
    if (!instance) {
            instance = [[ZYXSQLiteTools alloc] init];
    }

    
//    //second case
//    static dispatch_once_t onceToken;
//    
//    dispatch_once(&onceToken, ^{
//        instance = [[ZYXSQLiteTools alloc] init];
//    });
    
    return instance;
}

- (void)runSQL:(NSString *)sql
{
    CC(sqlite3_exec(_sqlite, sql.UTF8String, NULL, NULL, NULL));
}

- (void)startTransaction
{
    [self runSQL:@"begin"];
}

- (void)commitTransaction
{
    [self runSQL:@"commit"];
}

- (void)rollbackTransaction
{
    [self runSQL:@"rollback"];
}

- (void)checkSQLiteReturnCode:(int)ret
{
    if (ret != SQLITE_OK && ret != SQLITE_DONE) {
        //failed
        const char *err = sqlite3_errmsg(_sqlite);
        NSLog(@"SQLITE ERROR: %s", err);
        @throw [NSException exceptionWithName:@"SQLITE error" reason:[NSString stringWithCString:err encoding:NSUTF8StringEncoding] userInfo:nil];
    }
}

#pragma mark - Initializators

- (void)__runSQL:(NSString *)sql
{
    CC(sqlite3_exec(_sqlite, sql.UTF8String, NULL, NULL, NULL));
}

/**
 *  创建表
 */
- (void)__createTables
{
    [self __runSQL:@"create table property (name, value)"];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //拼接数据库地址
        NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        NSString *fileName = [docPath stringByAppendingPathComponent:@"local.db"];
        
        BOOL createTables = NO;
        //查询文件路径是否存在
        if (![[NSFileManager defaultManager] fileExistsAtPath:fileName]) {
            createTables = YES;
        }
        //打开数据库，不存在会新建一个
        int ret = sqlite3_open(fileName.UTF8String, &_sqlite);
        if (ret != SQLITE_OK) {
            //failed to open database
            NSLog(@"Failed to open database!");
            return nil;
        }
        
        if (createTables) {
            //[self __createTables];
            NSString *sql = @"create table property (name, value)";
            CC(sqlite3_exec(_sqlite, sql.UTF8String, NULL, NULL, NULL));

        }
    }
    
    return self;
}

//单例模式下该函数不会执行
- (void)dealloc
{
    sqlite3_close(_sqlite);
}

/**
 *  删除属性
 */
- (void)__removePropertyByName:(NSString *)name
{
    sqlite3_stmt *stmt;
    CC(sqlite3_prepare(_sqlite, "delete from property where name = ?", -1, &stmt, NULL));
    CC(sqlite3_bind_text(stmt, 1, name.UTF8String, -1, NULL));
    CC(sqlite3_step(stmt));
    CC(sqlite3_finalize(stmt));
}

- (void)setPropertyWithName:(NSString *)name stringValue:(NSString *)value
{
    [self __removePropertyByName:name];
    
    sqlite3_stmt *stmt;
    CC(sqlite3_prepare(_sqlite, "insert into property (name, value) values(?, ?)", -1, &stmt, NULL));
    CC(sqlite3_bind_text(stmt, 1, name.UTF8String, -1, NULL));
    CC(sqlite3_bind_text(stmt, 2, value.UTF8String, -1, NULL));
    CC(sqlite3_step(stmt));
    CC(sqlite3_finalize(stmt));
}

- (void)setPropertyWithName:(NSString *)name integerValue:(NSInteger)value
{
    [self __removePropertyByName:name];
    
    sqlite3_stmt *stmt;
    CC(sqlite3_prepare(_sqlite, "insert into property (name, value) values(?, ?)", -1, &stmt, NULL));
    CC(sqlite3_bind_text(stmt, 1, name.UTF8String, -1, NULL));
    CC(sqlite3_bind_int(stmt, 2, value));
    CC(sqlite3_step(stmt));
    CC(sqlite3_finalize(stmt));
}

- (void)setPropertyWithName:(NSString *)name boolValue:(BOOL)value
{
    [self __removePropertyByName:name];
    
    sqlite3_stmt *stmt;
    CC(sqlite3_prepare(_sqlite, "insert into property (name, value) values(?, ?)", -1, &stmt, NULL));
    CC(sqlite3_bind_text(stmt, 1, name.UTF8String, -1, NULL));
    CC(sqlite3_bind_int(stmt, 2, value ? 1 : 0));
    CC(sqlite3_step(stmt));
    CC(sqlite3_finalize(stmt));
}

- (NSString *)queryStringPropertyByName:(NSString *)name
{
    sqlite3_stmt *stmt;
    CC(sqlite3_prepare(_sqlite, "select value from property where name = ?", -1, &stmt, NULL));
    CC(sqlite3_bind_text(stmt, 1, name.UTF8String, -1, NULL));
    int ret = sqlite3_step(stmt);
    if (ret != SQLITE_ROW) {
        CC(sqlite3_finalize(stmt));
        return nil;
    }
    const char *val = (const char *)sqlite3_column_text(stmt, 0);
    NSString *valueString = [NSString stringWithCString:val encoding:NSUTF8StringEncoding];
    sqlite3_finalize(stmt);
    return valueString;
}

- (NSInteger)queryIntegerPropertyByName:(NSString *)name
{
    //[self __removePropertyByName:name];
    
    sqlite3_stmt *stmt;
    CC(sqlite3_prepare(_sqlite, "select value from property where name = ?", -1, &stmt, NULL));
    CC(sqlite3_bind_text(stmt, 1, name.UTF8String, -1, NULL));
    int ret = sqlite3_step(stmt);
    if (ret != SQLITE_ROW) {
        CC(sqlite3_finalize(stmt));
        return 0;
    }
    NSInteger value = sqlite3_column_int(stmt, 0);
    sqlite3_finalize(stmt);
    return value;
}

- (BOOL)queryBOOLProperytyByName:(NSString *)name
{
   //[self __removePropertyByName:name];
    sqlite3_stmt *stmt;
    CC(sqlite3_prepare(_sqlite, "select value from property where name = ?", -1, &stmt, NULL));
    CC(sqlite3_bind_text(stmt, 1, name.UTF8String, -1, NULL));
    int ret = sqlite3_step(stmt);
    if (ret != SQLITE_ROW) {
        CC(sqlite3_finalize(stmt));
        return 0;
    }
    NSInteger value = sqlite3_column_int(stmt, 0);
    sqlite3_finalize(stmt);
    return value != 0;
}

@end
