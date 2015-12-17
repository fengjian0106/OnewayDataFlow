//
//  ODFCounter.h
//  OnewayDataFlow
//
//  Created by fengjian on 15/10/18.
//  Copyright © 2015年 fengjian. All rights reserved.
//

#import <Foundation/Foundation.h>

//in swift, should use immutable "struct"
@interface ODFCounter : NSObject
@property(nonatomic, assign, readonly) NSInteger count;

- (instancetype)initWithCount: (NSInteger)count;


//TODO, add this function in a service ??
+ (ODFCounter *)counter: (ODFCounter *)counter add: (NSInteger)num;
+ (ODFCounter *)counter: (ODFCounter *)counter subtract: (NSInteger)num;
@end
