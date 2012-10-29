//
//  ConfigureWindowController.h
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ConfigureView.h"

@protocol ConfigureWindowDelegate <NSObject>
@optional
- (void)cancelRequested:(id)sender;
- (void)loginRequested:(id)sender withUsername:(NSString *)username password:(NSString *)password;
@end

@interface ConfigureWindowController : NSWindowController <ConfigureViewDelegate>

@property (nonatomic, strong) ConfigureView *configureView;
@property (nonatomic, assign) id <ConfigureWindowDelegate> delegate;
@property (nonatomic) ChattaState chattaState;

@end
