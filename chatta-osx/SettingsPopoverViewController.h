//
//  SettingsPopoverViewController.h
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol SettingsPopoverDelegate <NSObject>
@optional
- (void)logoutChatta;
- (void)loginChatta;
- (void)closePopover;
@end

@interface SettingsPopoverViewController : NSViewController <NSPopoverDelegate>

@property (nonatomic, assign) id <SettingsPopoverDelegate> delegate;
@property (weak) IBOutlet NSTextField *chattaTextField;
@property (weak) IBOutlet NSButton *timestampButton;
@property (weak) IBOutlet NSButton *soundsButton;

- (IBAction)stateButtonPushed:(id)sender;

@end
