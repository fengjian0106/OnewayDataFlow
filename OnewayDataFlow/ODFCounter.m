//
//  ODFCounter.m
//  OnewayDataFlow
//
//  Created by fengjian on 15/10/18.
//  Copyright © 2015年 fengjian. All rights reserved.
//

#import "ODFCounter.h"

///////////////////////////////////////////////////
@import CocoaLumberjack;
#ifdef DEBUG
static const DDLogLevel ddLogLevel = DDLogLevelVerbose;
#else
static const DDLogLevel ddLogLevel = DDLogLevelWarning;
#endif
///////////////////////////////////////////////////

@implementation ODFCounter

- (instancetype)initWithCount: (NSInteger)count {
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    _count = count;
    return self;
}

- (void)dealloc {
    DDLogVerbose(@"%s,  %d", __PRETTY_FUNCTION__, __LINE__);
}



+ (ODFCounter *)counter: (ODFCounter *)counter add: (NSInteger)num {
    return [[ODFCounter alloc] initWithCount:counter.count + num];
}

+ (ODFCounter *)counter: (ODFCounter *)counter subtract: (NSInteger)num {
    return [[ODFCounter alloc] initWithCount:counter.count - num];
}
@end
