//
//  ODFViewController.m
//  OnewayDataFlow
//
//  Created by fengjian on 15/10/18.
//  Copyright © 2015年 fengjian. All rights reserved.
//

#import "ODFViewController.h"
#import "ODFViewControllerViewModel.h"

@import Masonry;
@import ReactiveCocoa;
@import ReactiveCocoa.UIControl_RACSignalSupport;

///////////////////////////////////////////////////
@import CocoaLumberjack;
#ifdef DEBUG
static const DDLogLevel ddLogLevel = DDLogLevelVerbose;
#else
static const DDLogLevel ddLogLevel = DDLogLevelWarning;
#endif
///////////////////////////////////////////////////

@interface ODFViewController ()
@property (strong, nonatomic) ODFViewControllerViewModel *viewModel;

//normal view
@property (strong, nonatomic) UIButton *addButton;
@property (strong, nonatomic) UIButton *subtractButton;
@property (strong, nonatomic) UILabel *numberLabel;
@end

@implementation ODFViewController
- (instancetype)initWithViewModel: (ODFViewControllerViewModel *)viewModel {
    self = [super init];
    if (self) {
        _viewModel = viewModel;
    }
    
    return self;
}


- (instancetype)init {
    NSAssert(NO, @"%@ must be initialized using   + (id)initWithViewModel:", self.class);
    return nil;
}

- (void)dealloc {
    DDLogVerbose(@"%s,  %d", __PRETTY_FUNCTION__, __LINE__);
}

- (void)loadView {
    //Just do layout
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.view = [UIView new];
    
    self.addButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:self.addButton];
    self.subtractButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:self.subtractButton];
    
    self.numberLabel = [[UILabel alloc] init];
    [self.view addSubview:self.numberLabel];
    
    
    UIEdgeInsets padding = UIEdgeInsetsMake(20.0, 20.0, 0.0, 20.0);
    @weakify(self);
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.view.mas_top).with.offset(padding.top);
        make.left.equalTo(self.view.mas_left).with.offset(padding.left);
        make.right.equalTo(self.view.mas_right).with.offset(-padding.right);
        make.height.mas_equalTo(50.0);
    }];
    
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.view.mas_left).with.offset(20.0);
        make.right.equalTo(self.subtractButton.mas_left).with.offset(-20.0);
        
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-30.0);
        make.height.mas_equalTo(40.0);
        
        make.bottom.equalTo(@[self.subtractButton.mas_bottom]);
        make.height.equalTo(@[self.subtractButton.mas_height]);
        make.width.equalTo(@[self.subtractButton.mas_width]);
    }];
    
    [self.subtractButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self.view.mas_right).with.offset(-20.0);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self bindViewModel];
    
    
#if DEBUG
    // 2
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    // 3
    static dispatch_source_t source = nil;
    
    // 4
    __typeof(self) __weak weakSelf = self;
    
    // 5
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 6
        source = dispatch_source_create(DISPATCH_SOURCE_TYPE_SIGNAL, SIGSTOP, 0, queue);
        
        // 7
        if (source)
        {
            // 8
            dispatch_source_set_event_handler(source, ^{
                // 9
                NSLog(@"Hi, I am: %@", weakSelf);
            });
            dispatch_resume(source); // 10
        }
    });
#endif
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)bindViewModel {
    //one-time bind, no need to use RAC
    [self.addButton setTitle:@"add" forState:UIControlStateNormal];
    [self.subtractButton setTitle:@"sub" forState:UIControlStateNormal];
    
    self.addButton.backgroundColor = [UIColor greenColor];
    self.subtractButton.backgroundColor = [UIColor greenColor];
    self.numberLabel.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    //dynamic bind
    self.addButton.rac_command = self.viewModel.counterAddCommand;
    self.subtractButton.rac_command = self.viewModel.counterSubtractCommand;
    RAC(self.numberLabel, text) = self.viewModel.labelStringSignal;
    
    
    [self.viewModel.counterAddCommand.executing
     subscribeNext:^(NSNumber *x) {
         DDLogVerbose(@"\t\t%s, self.viewModel.counterAddCommand.executing, x is %@", __PRETTY_FUNCTION__, x.boolValue ? @"YES" : @"NO");
     } completed:^{
         DDLogVerbose(@"\t\t%s, self.viewModel.counterAddCommand.executing", __PRETTY_FUNCTION__);
     }];
    
    //!!不再需要关注executionSignals这个signal了
    [self.viewModel.counterAddCommand.executionSignals
     subscribeNext:^(id x) {
         DDLogVerbose(@"\t\t%s, self.viewModel.counterAddCommand.executionSignals, x is %@", __PRETTY_FUNCTION__, x);
     } completed:^{
         DDLogVerbose(@"\t\t%s, self.viewModel.counterAddCommand.executionSignals", __PRETTY_FUNCTION__);
     }];
    
    [self.viewModel.counterAddCommand.errors
     subscribeNext:^(NSNumber *x) {
         DDLogVerbose(@"\t\t%s, self.viewModel.counterAddCommand.errors, x is %@", __PRETTY_FUNCTION__, x.boolValue ? @"YES" : @"NO");
     } completed:^{
         DDLogVerbose(@"\t\t%s, self.viewModel.counterAddCommand.errors", __PRETTY_FUNCTION__);
     }];
}

@end
