//
//  ODFViewControllerViewModel.h
//  OnewayDataFlow
//
//  Created by fengjian on 15/10/18.
//  Copyright © 2015年 fengjian. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ODFFooStore;
@import ReactiveCocoa;

@interface ODFViewControllerViewModel : NSObject


//RACCommand
/*
 RACCommand input: _
 
 ColdSignal<NONE, NoError>
 Scheduler: main;
 Multicast: NO;
 */
@property (strong, nonatomic, readonly) RACCommand *counterAddCommand;

//RACCommand
/*
 RACCommand input: _
 
 ColdSignal<NSString, NoError>
 Scheduler: main;
 Multicast: NO;
 */
@property (strong, nonatomic, readonly) RACCommand *counterSubtractCommand;

/*
 ColdSignal<NSString, NoError>
 Scheduler: main;
 Multicast: NO;
 */
@property (strong, nonatomic, readonly) RACSignal *labelStringSignal;


- (instancetype)initWithFooStore: (ODFFooStore *)fooStore;
@end
