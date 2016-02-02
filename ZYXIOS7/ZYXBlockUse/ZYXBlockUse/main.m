//
//  main.m
//  ZYXBlockUse
//
//  Created by 7road on 15/12/24.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import <Foundation/Foundation.h>

id getBlockArray()
{
    int val = 10;
    return [[NSArray alloc] initWithObjects:[^{NSLog(@"block0:%d", val);} copy], [^{NSLog(@"block1:%d", val);} copy], nil];
}

int main(int argc, const char * argv[]) {
//    @autoreleasepool {
        // insert code here...
//        NSLog(@"Hello, World!");
//        
//        id obj = getBlockArray();
         typedef void (^blk_t) (id obj);
//        blk_t blk = (blk_t)[obj objectAtIndex:0];
//        blk();
//        
//        __block int val = 0;
//        void (^blka)(void) = [^{++val;} copy];
//        ++val;
//        blka();
//        NSLog(@"%d", val);
     
        blk_t blk;
        {
            id array = [[NSMutableArray alloc] init];
            id __weak array2 = array;
            NSLog(@"array1== %p",array);
            blk = [^(id obj){
                [array2 addObject:obj];
                NSLog(@"array count = %ld", [array2 count]);
                NSLog(@"array = %p", array2);
            } copy];
            
        }
    
        blk([[NSObject alloc] init]);
        blk([[NSObject alloc] init]);
        blk([[NSObject alloc] init]);
//    }
    return 0;
}
