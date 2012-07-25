//
//  SettingsPopoverViewController.h
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ChattaKit.h"

@protocol SettingsPopoverDelegate <NSObject>
@optional
- (void)logoutOfChatta;
- (void)loginToChatta;
- (void)closePopover;
@end

@interface SettingsPopoverViewController : NSViewController <NSPopoverDelegate>

@property (weak) IBOutlet NSTextField *chattaTextField;
@property (weak) IBOutlet NSButton *timestampButton;
@property (weak) IBOutlet NSButton *soundsButton;
@property (weak) IBOutlet NSButton *stateButton;

@property (nonatomic, assign) id <SettingsPopoverDelegate> delegate;
@property (nonatomic) ChattaState connectionState;

- (IBAction)stateButtonPushed:(id)sender;

@end
