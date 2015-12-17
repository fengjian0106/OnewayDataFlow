//
//  ODFAppDelegate.m
//  OnewayDataFlow
//
//  Created by fengjian on 15/10/18.
//  Copyright © 2015年 fengjian. All rights reserved.
//

#import "ODFAppDelegate.h"
#import "ODFFooStore.h"
#import "ODFViewController.h"
#import "ODFViewControllerViewModel.h"
#import "ODFFooStoreObserver.h"

///////////////////////////////////////////////////
@import CocoaLumberjack;
#ifdef DEBUG
static const DDLogLevel ddLogLevel = DDLogLevelVerbose;
#else
static const DDLogLevel ddLogLevel = DDLogLevelWarning;
#endif
///////////////////////////////////////////////////
#import "DDDispatchQueueLogFormatter.h"

@interface ODFAppDelegate ()
@property (nonatomic, strong, readwrite) ODFFooStoreObserver *storeObserver;
@end

@implementation ODFAppDelegate
- (void)configDDLog {
    DDDispatchQueueLogFormatter *dispatchQueueLogFormatter = [[DDDispatchQueueLogFormatter alloc] init];
    
    dispatchQueueLogFormatter.minQueueLength = 4;
    dispatchQueueLogFormatter.maxQueueLength = 0;
    
    
    [[DDASLLogger sharedInstance] setLogFormatter:dispatchQueueLogFormatter];
    [[DDTTYLogger sharedInstance] setLogFormatter:dispatchQueueLogFormatter];
    
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    [fileLogger setLogFormatter:dispatchQueueLogFormatter];
    
    [DDLog addLogger:fileLogger];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSLog(@"application didFinishLaunchingWithOptions");
    [self configDDLog];
    DDLogVerbose(@"DDLog...");
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    ODFFooStore *fooStroe = [[ODFFooStore alloc] init];
    ODFViewControllerViewModel *viewModel = [[ODFViewControllerViewModel alloc] initWithFooStore:fooStroe];
    ODFViewController *vc = [[ODFViewController alloc] initWithViewModel:viewModel];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:[[UIViewController alloc] init]];
    self.window.rootViewController = navVC;
    [navVC pushViewController:vc animated:YES];
    
    
    ////////////just test
    self.storeObserver = [[ODFFooStoreObserver alloc] initWithFooStore:fooStroe];
    /////////////////////////////////////////////////
    
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
