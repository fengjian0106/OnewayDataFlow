//
//  ODFFooStoreObserver.m
//  OnewayDataFlow
//
//  Created by fengjian on 15/10/19.
//  Copyright © 2015年 fengjian. All rights reserved.
//

#import "ODFFooStoreObserver.h"
#import "ODFFooStore.h"
#import "ODFCounter.h"
@import ReactiveCocoa;

///////////////////////////////////////////////////
@import CocoaLumberjack;
#ifdef DEBUG
static const DDLogLevel ddLogLevel = DDLogLevelVerbose;
#else
static const DDLogLevel ddLogLevel = DDLogLevelWarning;
#endif
///////////////////////////////////////////////////

@interface ODFFooStoreObserver ()
@property (nonatomic, strong, readwrite) ODFFooStore *fooStore;
@end

@implementation ODFFooStoreObserver

- (instancetype)initWithFooStore: (ODFFooStore *)fooStore {
    self = [super init];
    if (self) {
        _fooStore = fooStore;
        
        [self initPipline];
    }
    
    return self;
}

- (instancetype)init {
    NSAssert(NO, @"%s, must use - (instancetype)initWithFooStore:", __PRETTY_FUNCTION__);
    return nil;
}

- (void)dealloc {
    DDLogVerbose(@"%s,  %d", __PRETTY_FUNCTION__, __LINE__);
}

- (void)initPipline {
    @weakify(self);
    
    [[[self.fooStore.counterSignal
       doNext:^(id x) {
           DDLogVerbose(@"##<1>%s", __PRETTY_FUNCTION__);
       }]
      deliverOn: [RACScheduler mainThreadScheduler]]
     subscribeNext:^(ODFCounter *counter) {
         @strongify(self);
         DDLogDebug(@"##<2>%s, %@, %@, %ld", __FUNCTION__, self, counter, counter.count);
     } completed:^{
         DDLogVerbose(@"##<3>%s", __PRETTY_FUNCTION__);
     }];
}
@end
