//
//  main.m
//  ZYXCFRef
//
//  Created by 7road on 15/11/16.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
       
//        CFArrayCallBacks nrCallbacks = kCFTypeArrayCallBacks;
//        
//        nrCallbacks.retain = NULL;
//        nrCallbacks.release = NULL;
//        
//        CFMutableArrayRef nrArray = CFArrayCreateMutable(NULL, 0, &nrCallbacks);
//        
//        CFMutableStringRef string = CFStringCreateMutable(NULL, 0);
//        CFStringAppendCString(string, "STUFF", kCFStringEncodingUTF8);
//        CFArrayAppendValue(nrArray, string);
//        
//        CFShow(nrArray);
//        CFStringLowercase(string, NULL);
//        CFShow(string);
//        CFRelease(string);
//        CFShow(nrArray);
        
//        Dictionary不能再使用这种方法来使NULL为key，需要传入NULL作为KeyCallBacks
//        CFDictionaryKeyCallBacks cb = kCFTypeDictionaryKeyCallBacks;
//        cb.retain = NULL;
//        cb.release = NULL;
        
        CFMutableDictionaryRef dict = CFDictionaryCreateMutable(NULL, 0, NULL, &kCFTypeDictionaryValueCallBacks);
        CFDictionarySetValue(dict, NULL, CFSTR("Foo"));
        
        const void *value;
        Boolean fooPresent = CFDictionaryGetValueIfPresent(dict, NULL, &value);
        printf("fooPresent: %d\n", fooPresent);
        printf("values equal: %d\n", CFEqual(value, CFSTR("Foo")));
                                                                
    }
    return 0;
}
