//
//  BNRItem.h
//  RandomItems
//
//  Created by 7road on 15/7/21.
//  Copyright (c) 2015年 7road. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRItem : NSObject
//{
//    NSString * _itemName;
//    NSString * _serialNum;
//    int _valueInDollars;
//    NSDate *_dateCreated;//只读，不能修改
//    
//    //强引用与弱引用
//    BNRItem *_containedItem;
//    __weak BNRItem *_container;
//}


//类方法
+(instancetype) randomItem;
//BNItem类的指定初始化方法
-(instancetype)initWithItemName:(NSString *)name
                 valueInDollars:(int)value
                   serialNumber:(NSString *)sNumber;
-(instancetype) initWithItemName:(NSString *)name;

-(instancetype) initWithItemName:(NSString *)name
                    serialNumber:(NSString *)sNumber;


//-(void)setContainedItem:(BNRItem *)item;
//-(BNRItem *)containedItem;
//
//-(void)setContainer:(BNRItem *)item;
//-(BNRItem *)container;
//
//
//-(void) setItemName:(NSString *)str;
//-(NSString *)itemName;
//
//-(void) setSerialNumber:(NSString *)str;
//-(NSString *)serialNumber;
//
//-(void) setValueInDollars:(int)v;
//-(int)valueInDollars;
//
//-(NSDate *) dateCreated;

//@property属性，可以为类声明实例变量，并实现存取方法
@property (nonatomic,strong)BNRItem *containedItem;
@property (nonatomic,weak)BNRItem *container;

@property (nonatomic,copy)NSString *itemName;
@property (nonatomic,copy)NSString *serialNumber;
@property (nonatomic)int valueInDollars;
@property (nonatomic,readonly,strong)NSDate *dateCreated;

@end




