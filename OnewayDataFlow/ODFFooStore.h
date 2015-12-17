//
//  ODFFooStore.h
//  OnewayDataFlow
//
//  Created by fengjian on 15/10/18.
//  Copyright © 2015年 fengjian. All rights reserved.
//

#import <Foundation/Foundation.h>


//#define RACCOMMAND_IN_STORE

@class ODFCounter;
@import ReactiveCocoa;


@interface ODFFooStore : NSObject
/**
 use RACObserve to get RACSignal
 kvo is not thread safe
 
 ColdSignal<[ODFCounter], NoError>
 Scheduler: current;
 Multicast: NO;
 */
@property (strong, nonatomic, readonly) RACSignal *counterSignal;

- (void)updateCounter: (ODFCounter *)counter;

@end



