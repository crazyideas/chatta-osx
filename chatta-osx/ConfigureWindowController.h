//
//  ConfigureWindowController.h
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CKConstants.h"
#import "ConfigureView.h"
#import "CKEmailAddressFormatter.h"

@protocol ConfigureWindowDelegate <NSObject>
@optional
- (void)loginRequested:(id)sender withUsername:(NSString *)username password:(NSString *)password;
- (void)logoutRequested:(id)sender;
- (void)removeWindowRequested:(id)sender;
@end

@interface ConfigureWindowController : NSWindowController <ConfigureViewDelegate, NSTextFieldDelegate>

@property (nonatomic) ChattaState chattaState;
@property (nonatomic, strong) ConfigureView *configureView;
@property (nonatomic, strong) CKEmailAddressFormatter *emailAddressFormatter;

@property (nonatomic, assign) id <ConfigureWindowDelegate> delegate;

@end
