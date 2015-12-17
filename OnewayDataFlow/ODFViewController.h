//
//  ODFViewController.h
//  OnewayDataFlow
//
//  Created by fengjian on 15/10/18.
//  Copyright © 2015年 fengjian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ODFViewControllerViewModel;

@interface ODFViewController : UIViewController
- (instancetype)initWithViewModel: (ODFViewControllerViewModel *)viewModel;
@end
