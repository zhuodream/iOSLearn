//
//  main.swift
//  ZYXSwiftLearn
//
//  Created by 7road on 15/12/9.
//  Copyright © 2015年 zhuo. All rights reserved.
//

import Foundation

print("Hello, World!")

var optionalName: String? = "zhuo"
optionalName = nil
var greeting = "Hello"

if let name = optionalName{
    greeting = "Hello, \(name)"
}
else{
    greeting = "Hello, aaaaa"
}

print(greeting)