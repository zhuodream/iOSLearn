//
//  main.m
//  ZYXPerson
//
//  Created by 7road on 15/12/22.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        Person *person = [[Person alloc] init];
        [person setGivenName:@"Bob"];
        [person setSurname:@"Jones"];
        
        NSLog(@"%@  %@", [person givenName], [person surname]);
    }
    return 0;
}
