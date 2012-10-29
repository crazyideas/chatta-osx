//
//  ConfigureWindowController.m
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import "ConfigureWindowController.h"

@implementation ConfigureWindowController

- (id)init
{
    self = [super init];
    if (self) {
        NSUInteger configureWindowStyleMask = NSClosableWindowMask |
            NSMiniaturizableWindowMask | NSTitledWindowMask | NSTitledWindowMask;
        NSRect configureWindowFrame = NSMakeRect(0, 0, 480, 270);
        
        self.window = [[NSWindow alloc] initWithContentRect:configureWindowFrame
            styleMask:configureWindowStyleMask backing:NSBackingStoreBuffered defer:NO];
        self.configureView = [[ConfigureView alloc] initWithFrame:configureWindowFrame];
        
        self.configureView.delegate = self;
        self.window.windowController = self;
        self.window.contentView = self.configureView;
    }
    return self;
}

#pragma mark - Properties

- (void)setChattaState:(ChattaState)chattaState
{
    self.configureView.rightButton.title = (ChattaStateConnected) ? @"Logout" : @"Login";
    _chattaState = chattaState;
}

#pragma mark - Configure View Delegates

- (void)leftButtonAction:(id)sender
{
    NSLog(@"[+] ConfigureWindowController: cancelRequested");
    if (self.delegate != nil) {
        [self.delegate cancelRequested:sender];
    }
}

- (void)rightButtonAction:(id)sender
{
    NSLog(@"[+] ConfigureWindowController: loginRequested");
    if (self.delegate != nil) {
        if (self.chattaState == ChattaStateDisconnected) {
            [self.delegate loginRequested:sender
                withUsername:self.configureView.usernameTextField.stringValue
                password:self.configureView.passwordTextField.stringValue];
        } else {
            [self.delegate cancelRequested:sender];
        }
    }
}

@end
