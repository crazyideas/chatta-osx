//
//  SettingsPopoverViewController.m
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import "SettingsPopoverViewController.h"

@implementation SettingsPopoverViewController

@synthesize delegate        = _delegate;
@synthesize chattaTextField = _chattaTextField;
@synthesize timestampButton = _timestampButton;
@synthesize soundsButton    = _soundsButton;
@synthesize connectionState = _connectionState;
@synthesize stateButton     = _stateButton;

- (void)setConnectionState:(ChattaState)connectionState
{
    self.stateButton.title = (connectionState == ChattaStateConnected) ? @"Logout of Chatta" : @"Login to Chatta";
    _connectionState = connectionState;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)awakeFromNib
{
    self.chattaTextField.font = [NSFont fontWithName:@"Cookie-Regular" size:40];
    self.chattaTextField.textColor = [NSColor colorWithCalibratedRed:90/255.0 green:67/255.0 blue:210/255.0 alpha:1.0];
    
    self.stateButton.title = (self.connectionState == ChattaStateConnected) ? @"Logout of Chatta" : @"Login to Chatta";
    
    [self.timestampButton setEnabled:NO];
    [self.soundsButton setEnabled:NO];
}

#pragma mark - State Button Action

- (IBAction)stateButtonPushed:(id)sender
{    
    if (self.delegate != nil) {
        if (self.connectionState == ChattaStateConnected) {
            [self.delegate logoutOfChatta];
        } else { 
            [self.delegate loginToChatta];
        }
    }
}
@end
