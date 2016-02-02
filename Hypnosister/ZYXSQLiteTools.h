//
//  ZYXSQLiteTools.h
//  ZYXSQLiteTools
//
//  Created by 卓酉鑫 on 15/9/24.
//  Copyright © 2015年 卓酉鑫. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

/**
 *  SQLite数据库操作单例
 */

/**
 *  检查SQLite执行操作返回的结果
 *
 *  @param __ret__   SQLite执行方法
 *
 *  @return YES or NO
 */
#define CC(__ret__) [[ZYXSQLiteTools getInstance] checkSQLiteReturnCode:__ret__]

@interface ZYXSQLiteTools : NSObject

@property (nonatomic,readonly) sqlite3 *sqlite;
/**
 *  获得SQLite操作单例
 *
 *  @return 返回ZYXSQLiteTools单例
 */
+ (instancetype)getInstance;

/**
 *  执行sql语句
 *
 *  @param sql sql语句
 */
- (void)runSQL:(NSString *)sql;

/**
 *  开始事务
 */
- (void)startTransaction;
/**
 *  提交事务
 */
- (void)commitTransaction;

/**
 *  回滚事务
 */
- (void)rollbackTransaction;

/**
 *  检查SQLite执行结果
 */
- (void)checkSQLiteReturnCode:(int)ret;

/**
 *  通过名字设置SQLite中的字段为NSString的属性值
 *
 *  @param name  属性名
 *  @param value 对应NSString的值
 */
- (void)setPropertyWithName:(NSString *)name stringValue:(NSString *)value;

/**
 *  通过名字设置SQLite中的字段为NSInteger的属性值
 *
 *  @param name  属性名
 *  @param value 对应NSInteger的值
 */
- (void)setPropertyWithName:(NSString *)name integerValue:(NSInteger)value;

/**
 *  通过名字设置SQLite中的字段为BOOL的属性值
 *
 *  @param name  属性名
 *  @param value 对应BOOL的值
 */
- (void)setPropertyWithName:(NSString *)name boolValue:(BOOL)value;

/**
 *  查询字段为NSString名为name的值
 *
 *  @param name 属性名
 *
 *  @return 属性名对应的值
 */
- (NSString *)queryStringPropertyByName:(NSString *)name;

/**
 *  查询字段为NSInterger名为name的值
 *
 *  @param name 属性名
 *
 *  @return 属性名对应的值
 */
- (NSInteger)queryIntegerPropertyByName:(NSString *)name;

/**
 *  查询字段为BOOL名为name的值
 *
 *  @param name 属性名
 *
 *  @return 属性名对应的值
 */
- (BOOL)queryBOOLProperytyByName:(NSString *)name;

@end
