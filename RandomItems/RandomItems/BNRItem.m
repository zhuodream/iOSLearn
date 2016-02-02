//
//  BNRItem.m
//  RandomItems
//
//  Created by 7road on 15/7/21.
//  Copyright (c) 2015年 7road. All rights reserved.
//

#import "BNRItem.h"

@implementation BNRItem

+(instancetype)randomItem
{
    //创建不可变数组对象，包含三个形容词
    NSArray * randomAdjectiveList=@[@"Fluffy",@"Rusty",@"Shiny"];
    
    //创建不可变数组对象，包含三个名词
    NSArray * randomNounList=@[@"Bear",@"Spork",@"Mac"];
    
    //根据数组对象所含对象的个数，得到随机索引
    //NSInteger 是unsigned long的类型定义
    NSInteger adjectiveIndex=arc4random()%[randomAdjectiveList count];
    NSInteger nounIndex=arc4random()%[randomNounList count];
    
    //可以使用下标语法来进行访问randomAdjectiveList[adjectiveIndex]
    NSString *randomName=[NSString stringWithFormat:@"%@ %@",
                          [randomAdjectiveList objectAtIndex:adjectiveIndex],
                          [randomNounList objectAtIndex:nounIndex]];
    
    int randomValue=arc4random()%100;
    
    NSString *randomSerialNumber=[NSString stringWithFormat:@"%c%c%c%c%c",
                                  '0'+arc4random()%10,
                                  'A'+arc4random()%26,
                                  '0'+arc4random()%10,
                                  'A'+arc4random()%26,
                                  '0'+arc4random()%10];
    BNRItem *newItem=[[self alloc] initWithItemName:randomName
                                     valueInDollars:randomValue
                                       serialNumber:randomSerialNumber];
    return newItem;
}


-(instancetype)initWithItemName:(NSString *)name valueInDollars:(int)value serialNumber:(NSString *)sNumber
{
    //调用父类的指定初始化方法
    self=[super init];
    
    if(self)
    {
        _itemName=name;
        _serialNumber=sNumber;
        _valueInDollars=value;
        
        //设置_dateCreated为当前时间
        _dateCreated=[[NSDate alloc] init];
    }
    
    return self;
}

-(instancetype)initWithItemName:(NSString *)name
{
    return [self initWithItemName:name valueInDollars:0 serialNumber:@""];
}

-(instancetype)initWithItemName:(NSString *)name serialNumber:(NSString *)sNumber
{
    return [self initWithItemName:name valueInDollars:0 serialNumber:sNumber];
}

//覆盖父类的初始化方法
-(instancetype)init
{
    return [self initWithItemName:@"Item"];
}

-(void)setContainedItem:(BNRItem *)item
{
    _containedItem=item;
    
    //将item加入容纳它的BNRItem对象时，会将它的container实例变量指向容纳它的对象
    item.container=self;
}
//
//-(BNRItem *)containedItem
//{
//    return _containedItem;
//}
//
//-(void)setContainer:(BNRItem *)item
//{
//    _container=item;
//}
//
//-(BNRItem *)container
//{
//    return _container;
//}
//
//
//-(void)setItemName:(NSString *)str
//{
//    _itemName=str;
//}
//
//-(NSString *)itemName
//{
//    return _itemName;
//}
//
//-(void)setSerialNumber:(NSString *)str
//{
//    _serialNum=str;
//}
//
//-(NSString *)serialNumber
//{
//    return _serialNum;
//}
//
//-(void)setValueInDollars:(int)v
//{
//    _valueInDollars=v;
//}
//
//-(int)valueInDollars
//{
//    return _valueInDollars;
//}
//
//-(NSDate *)dateCreated
//{
//    return _dateCreated;
//}

-(NSString *)description
{
    NSString * descriptionString=
        [[NSString alloc] initWithFormat:@"%@ (%@): Worth $%d,recorded on%@",
                            self.itemName,
                            self.serialNumber,
                            self.valueInDollars,
                            self.dateCreated];
    return descriptionString;
}

-(void)dealloc
{
    NSLog(@"Destroyed:%@",self);
}

@end
