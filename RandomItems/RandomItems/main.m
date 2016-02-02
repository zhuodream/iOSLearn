//
//  main.m
//  RandomItems
//
//  Created by 7road on 15/7/21.
//  Copyright (c) 2015年 7road. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNRItem.h"
int main(int argc, const char * argv[]) {
    @autoreleasepool {
//        // insert code here...
//        NSLog(@"Hello, World!");
        //创建一个NSMutableArray对象，并用items保存变量地址
        NSMutableArray *items=[[NSMutableArray alloc] init];
//        
//        //向items所指向的NSMutableArray对象发送addObject:消息
//        [items addObject:@"One"];
//        [items addObject:@"Two"];
//        [items addObject:@"Three"];
//        
//        //继续向同一个对象发送消息insertObject:atIndex
//        [items insertObject:@"Zero" atIndex:0];
//        
//        //使用快速枚举遍历对象,只能遍历，如有添加和删除操作应使用普通for循环
//        for(NSString *item in items)
//        {
//            NSLog(@"%@",item);
//        }
//        
////        BNRItem *item=[[BNRItem alloc] init];
////        
////        //[item setItemName:@"Red sofa"];
////        //使用点语法存取变量，多使用这个方法
////        item.itemName=@"Red sofa";
////        //[item setSerialNumber:@"A1B2C"];
////        item.serialNumber=@"A1B2C";
////        //[item setValueInDollars:100];
////        item.valueInDollars=100;
//        
////        NSLog(@"%@ %@ %@ %d",[item itemName],[item dateCreated],[item serialNumber],[item valueInDollars]);
////        
////         NSLog(@"%@ %@ %@ %d",item.itemName,item.dateCreated,item.serialNumber,item.valueInDollars);
//
//        BNRItem *item=[[BNRItem alloc] initWithItemName:@"Red sofa" valueInDollars:100 serialNumber:@"A1B2C"];
//        
//        NSLog(@"%@",item);
//        BNRItem *itemwithName=[[BNRItem alloc] initWithItemName:@"Red sofa"];
//        NSLog(@"%@",itemwithName);
//        BNRItem *itemwithNoName=[[BNRItem alloc] init];
//        
//        NSLog(@"%@",itemwithNoName);
        
        
//        for(int i=0;i<10;i++)
//        {
//            BNRItem *item=[BNRItem randomItem];
//            [items addObject:item];
//        }
        
        BNRItem *backpack=[[BNRItem alloc] initWithItemName:@"Backpack"];
        [items addObject:backpack];
        
        BNRItem *calculator=[[BNRItem alloc] initWithItemName:@"Calculator"];
        [items addObject:calculator];
        
        backpack.containedItem=calculator;
        
        backpack=nil;
        calculator=nil;

        for(BNRItem * item in items)
        {
            NSLog(@"%@",item);
        }
        
        //释放items指向的对象
        NSLog(@"Setting items to nil....");
        items=nil;
    }
  
    return 0;
}
