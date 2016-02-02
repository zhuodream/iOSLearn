//
//  main.cpp
//  ZYXSQLiteTools
//
//  Created by 7road on 15/9/24.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#include <iostream>
#import "ZYXSQLiteTools.h"

int main(int argc, const char * argv[]) {
    
    ZYXSQLiteTools *instance = [ZYXSQLiteTools getInstance];
    [instance setPropertyWithName:@"userId" stringValue:@"zhuoyouxin"];
    [instance setPropertyWithName:@"passwd" stringValue:@"123456"];
    
    NSString *name = [instance queryStringPropertyByName:@"userId"];
    NSString *passwd = [instance queryStringPropertyByName:@"passwd"];
    NSLog(@"name = %@, passwd = %@",name,passwd);
    
//    sqlite3 *sqlite;
//    //拼接数据库地址
//    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
//    NSString *fileName = [docPath stringByAppendingPathComponent:@"local.db"];
//    sqlite3_open(fileName.UTF8String, &sqlite);
//    
//    sqlite3_exec(sqlite, "create table property (name, value)", NULL, NULL, NULL);
//    sqlite3_stmt *stmt;
//    sqlite3_prepare(sqlite, "insert into property (name, value) values (?, ?)", -1, &stmt, NULL);
//    sqlite3_bind_text(stmt, 1, "userid", -1, NULL);
//    sqlite3_bind_text(stmt, 2, "zhuoyouxin", -1, NULL);
//    sqlite3_step(stmt);
//    sqlite3_finalize(stmt);
//    
//    sqlite3_prepare(sqlite, "select value from property where name = ?", -1, &stmt, NULL);
//    sqlite3_bind_text(stmt, 1, "userid", -1, NULL);
//    int ret =sqlite3_step(stmt);
//    if (ret != SQLITE_ROW) {
//        sqlite3_finalize(stmt);
//    }
//    const char *val = (const char *)sqlite3_column_text(stmt, 0);
//    printf("val = %s",val);

    return 0;
}
