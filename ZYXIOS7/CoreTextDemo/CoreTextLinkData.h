//
//  CoreTextLinkData.h
//  CoreTextDemo
//
//  Created by 7road on 16/1/4.
//  Copyright © 2016年 zhuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreTextLinkData : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, assign) NSRange range;

@end
