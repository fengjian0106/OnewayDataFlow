//
//  ODFViewControllerViewModel.m
//  OnewayDataFlow
//
//  Created by fengjian on 15/10/18.
//  Copyright © 2015年 fengjian. All rights reserved.
//

#import "ODFViewControllerViewModel.h"
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

@interface ODFViewControllerViewModel ()
@property (strong, nonatomic, readwrite) ODFFooStore *fooStore;

@property (strong, nonatomic, readwrite) RACCommand *counterAddCommand;
@property (strong, nonatomic, readwrite) RACCommand *counterSubtractCommand;
@property (strong, nonatomic, readwrite) RACSignal *labelStringSignal;
@end

@implementation ODFViewControllerViewModel
#pragma mark -
#pragma mark Setters and Getters


#pragma mark public and private func
- (void)dealloc {
    DDLogVerbose(@"%s,  %d", __PRETTY_FUNCTION__, __LINE__);
}

- (instancetype)initWithFooStore: (ODFFooStore *)fooStore {
    self = [super init];
    if (self) {
        _fooStore = fooStore;
        
        [self initPipline];
    }
    
    return self;
}

- (instancetype)init {
    NSAssert(NO, @"%s, must use - (instancetype)initWithfooStore:", __PRETTY_FUNCTION__);
    return nil;
}

- (void)initPipline {
    @weakify(self);
    
    self.labelStringSignal = [[[[self.fooStore.counterSignal
                                 distinctUntilChanged]//!!
                                map:^id(ODFCounter *counter) {
                                    @strongify(self);
                                    DDLogVerbose(@"==<1>%s", __PRETTY_FUNCTION__);
                                    NSString *label = counter ? [NSString stringWithFormat:@"%ld", counter.count]: @"";
                                    return label;
                                }]
                               deliverOn:[RACScheduler mainThreadScheduler]]
                              doNext:^(id x) {
                                  DDLogVerbose(@"==<2>%s", __PRETTY_FUNCTION__);
                              }];
    
    
    self.counterAddCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        RACSignal *business = [[[self.fooStore.counterSignal
                                 take:1]//just need current value, so take only one
                                deliverOnMainThread]
                               map:^id(ODFCounter *counter) {
                                   //<1>business logic
                                   return [ODFCounter counter:counter add:2];
                               }];
        
        return [[business
                 map:^id(ODFCounter *c) {
                     @strongify(self);
                     //<2>update store
                     [self.fooStore updateCounter:c];//
                     return c;
                 }]
                then:^RACSignal *{
                    //<3>UI should not use "nextEvent" of this command, so ignore all "next"
                    return [RACSignal empty];
                }];
    }];
    
    
    self.counterSubtractCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        RACSignal *business = [[[self.fooStore.counterSignal
                                 take:1]
                                deliverOnMainThread]
                               map:^id(ODFCounter *counter) {
                                   return [ODFCounter counter:counter subtract:2];
                               }];
        
        return [[business
                 map:^id(ODFCounter *c) {
                     @strongify(self);
                     [self.fooStore updateCounter:c];
                     return c;
                 }]
                then:^RACSignal *{
                    return [RACSignal empty];
                }];
    }];
}
@end
