//
//  DynamicClass.m
//  ZYXDynamicClass
//
//  Created by 7road on 15/11/11.
//  Copyright © 2015年 zhuo. All rights reserved.
//
//
//#import <objc/objc.h>
//#import <objc/runtime.h>
//
//BOOL CreateClassDefinition(const char *name, const char *superclassName)
//{
//    Class *meta_class;
//    Class *super_class;
//    Class *new_class;
//    Class *root_class;
//    va_list args;
//    
//    //确保父类存在
//    //super_class = (Class *)objc_unretainedPointer(objc_lookUpClass(superclassName));
//    super_class = (Class *)((__bridge void *)objc_lookUpClass(superclassName));
//    if (super_class == nil)
//    {
//        return NO;
//    }
//    
//    //确保要创建的类不存在
//    if (objc_lookUpClass(name) != nil)
//    {
//        return NO;
//    }
//    
//    //查找rootclass ,因为meta class的isa指向rootclass 的metaclass
//    root_class = super_class;
//    
//    while (root_class->super_class != nil)
//    {
//        root_class = root_class->super_class;
//    }
//    return  NO;
//}
