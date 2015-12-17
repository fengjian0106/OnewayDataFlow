//
//  ODFFooStoreObserver.h
//  OnewayDataFlow
//
//  Created by fengjian on 15/10/19.
//  Copyright © 2015年 fengjian. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ODFFooStore;

@interface ODFFooStoreObserver : NSObject
- (instancetype)initWithFooStore: (ODFFooStore *)fooStore;
@end
