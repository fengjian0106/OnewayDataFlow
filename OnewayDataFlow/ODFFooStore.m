//
//  ODFFooStore.m
//  OnewayDataFlow
//
//  Created by fengjian on 15/10/18.
//  Copyright © 2015年 fengjian. All rights reserved.
//

#import "ODFFooStore.h"
#import "ODFCounter.h"


///////////////////////////////////////////////////
@import CocoaLumberjack;
#ifdef DEBUG
static const DDLogLevel ddLogLevel = DDLogLevelVerbose;
#else
static const DDLogLevel ddLogLevel = DDLogLevelWarning;
#endif
///////////////////////////////////////////////////

@interface ODFFooStore ()
@property (strong, nonatomic, readwrite) dispatch_queue_t isolationQueue;
@property (strong, nonatomic, readwrite) dispatch_queue_t workQueue;

@property (strong, nonatomic, readwrite) ODFCounter *counter;
@end



@implementation ODFFooStore

@synthesize counter = _counter;
- (ODFCounter *)counter {
    dispatch_sync(self.isolationQueue, ^{
        if (!_counter) {
            _counter = [[ODFCounter alloc] initWithCount:5];
        }
    });
    
    return _counter;
}

- (void)setCounter:(ODFCounter *)counter {
    DDLogVerbose(@"**ODFCounter setCounter, before isolationQueue, %s", __PRETTY_FUNCTION__);
    dispatch_barrier_async(self.isolationQueue, ^{
        _counter = counter;
        DDLogVerbose(@"**ODFCounter setCounter, in isolationQueue, %s", __PRETTY_FUNCTION__);
    });
}

- (void)updateCounter: (ODFCounter *)counter {
    self.counter = counter;
}


- (instancetype)init {
    self = [super init];
    
    if (self) {
        NSString *label = [NSString stringWithFormat:@"com.OnewayDataFlow.%@.isolation.%p", [self class], self];
        _isolationQueue = dispatch_queue_create([label UTF8String], DISPATCH_QUEUE_CONCURRENT);
        
        label = [NSString stringWithFormat:@"com.OnewayDataFlow.%@.isolation.%p", [self class], self];
        _workQueue = dispatch_queue_create([label UTF8String], DISPATCH_QUEUE_SERIAL);
        
        _counterSignal = RACObserve(self, counter);
    }
    
    return self;
}

- (void)dealloc {
    DDLogVerbose(@"%s,  %d", __PRETTY_FUNCTION__, __LINE__);
}

@end

