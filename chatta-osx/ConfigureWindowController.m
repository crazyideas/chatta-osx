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
        NSRect configureWindowFrame = normalRectFrame;
        
        self.window = [[NSWindow alloc] initWithContentRect:configureWindowFrame
            styleMask:configureWindowStyleMask backing:NSBackingStoreBuffered defer:NO];
        self.configureView = [[ConfigureView alloc] initWithFrame:configureWindowFrame];
        
        self.emailAddressFormatter = [[CKEmailAddressFormatter alloc] init];
        
        self.configureView.delegate = self;
        self.configureView.passwordTextField.delegate = self;
        self.configureView.usernameTextField.delegate = self;
        self.configureView.usernameTextField.formatter = self.emailAddressFormatter;
        
        [self validateFieldsAndUpdateButtons];
        
        self.window.windowController = self;
        self.window.contentView = self.configureView;
    }
    return self;
}


- (void)validateFieldsAndUpdateButtons
{
    NSString *usernameString = self.configureView.usernameTextField.stringValue;
    NSString *passwordString = self.configureView.passwordTextField.stringValue;
    BOOL usernameValid = NO;
    BOOL passwordValid = NO;
    
    // check if username is valid
    if ([CKEmailAddressFormatter isValidEmailAddress:usernameString]) {
        usernameValid = YES;
    } else {
        usernameValid = NO;
    }
    
    // check if password is valid
    if (passwordString.length > 0) {
        passwordValid = YES;
    } else {
        passwordValid = NO;
    }
    
    [self.configureView.rightButton setEnabled:usernameValid && passwordValid];
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
    NSLog(@"[+] ConfigureWindowController: leftButtonAction");
    if (self.delegate != nil) {
        if (self.configureView.configureViewState == ConfigureViewStateProgress) {
            [self.delegate logoutRequested:sender];
        }
        [self.delegate removeWindowRequested:sender];
    }
}

- (void)rightButtonAction:(id)sender
{
    NSLog(@"[+] ConfigureWindowController: rightButtonAction");
    if (self.delegate != nil) {
        if (self.chattaState == ChattaStateDisconnected || self.chattaState == ChattaStateErrorDisconnected) {
            [self.delegate loginRequested:sender
                withUsername:self.configureView.usernameTextField.stringValue
                password:self.configureView.passwordTextField.stringValue];
        } else {
            [self.delegate logoutRequested:sender];
        }
    }
}

#pragma mark - NSTextFieldDelegate

- (void)controlTextDidChange:(NSNotification *)object
{
    [self validateFieldsAndUpdateButtons];
}


@end
