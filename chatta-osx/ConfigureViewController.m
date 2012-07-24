//
//  ConfigureViewController.m
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import "ConfigureViewController.h"

@implementation ConfigureViewController

@synthesize delegate               = _delegate;
@synthesize emailAddressFormatter  = _emailAddressFormatter;
@synthesize chattaTextField        = _chattaTextField;
@synthesize usernameTextField      = _usernameTextField;
@synthesize passwordTextField      = _passwordTextField;
@synthesize loginProgressIndicator = _loginProgressIndicator;
@synthesize firstPreviousButton    = _firstPreviousPressed;
@synthesize firstNextButton        = _firstNextButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.emailAddressFormatter = [[EmailAddressFormatter alloc] init];
    }
    
    return self;
}

- (void)awakeFromNib
{
    NSDockTile *tile = [[NSApplication sharedApplication] dockTile];
    tile.badgeLabel = @"1";
    
    self.chattaTextField.font = [NSFont fontWithName:@"Cookie-Regular" size:60];
    self.chattaTextField.textColor = [NSColor colorWithCalibratedRed:90/255.0 green:67/255.0 blue:210/255.0 alpha:1.0];
    
    self.passwordTextField.delegate = self;
    self.usernameTextField.delegate = self;
    self.usernameTextField.formatter = self.emailAddressFormatter;
    
    [self configureSheetWillOpen];
}

- (void)configureSheetWillOpen
{
    [self validateFieldsAndUpdateButtons];
    [self.usernameTextField becomeFirstResponder];
}

- (void)configureSheetWillClose
{
    [self.loginProgressIndicator stopAnimation:self];        
    self.usernameTextField.stringValue = @"";
    self.passwordTextField.stringValue = @"";
}

- (void)validateFieldsAndUpdateButtons
{
    NSString *usernameString = self.usernameTextField.stringValue;
    NSString *passwordString = self.passwordTextField.stringValue;
    BOOL usernameValid = NO;
    BOOL passwordValid = NO;
    
    // check if username is valid
    if ([EmailAddressFormatter isValidEmailAddress:usernameString]) {
        usernameValid = YES;
    } else {
        passwordValid = NO;
    }
    
    // check if password is valid
    if (passwordString.length > 0) {
        passwordValid = YES;
    } else { 
        passwordValid = NO;
    }
    
    [self.firstNextButton setEnabled:usernameValid && passwordValid];
    [self.firstPreviousButton setEnabled:NO];
}

#pragma mark - NSTextFieldDelegate

- (void)controlTextDidChange:(NSNotification *)object
{
    [self validateFieldsAndUpdateButtons];
}

#pragma mark - Core Animation Helper Methods

- (void)transitionViewAnimationWithOffset:(NSInteger)offset
{
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:0.22];
    
    NSPoint newViewPoint = NSMakePoint(self.view.frame.origin.x + offset, self.view.frame.origin.y);
    [self.view.animator setFrameOrigin:newViewPoint];
    
    [NSAnimationContext endGrouping];
}

- (void)showLoginView
{
    [self transitionViewAnimationWithOffset:-480];
}

- (void)showContactImportView
{
    [self transitionViewAnimationWithOffset:+480];
}

#pragma mark - Button Action Methods

- (IBAction)firstNextPushed:(id)sender
{
    if (self.delegate != nil) {
        [self.delegate loginPushedUsername:self.usernameTextField.stringValue 
                                  password:self.passwordTextField.stringValue];
    }
    
    self.loginProgressIndicator.usesThreadedAnimation = YES;
    [self.loginProgressIndicator startAnimation:self];
}

- (IBAction)firstCancelPushed:(id)sender
{    
    if (self.delegate != nil) {
        [self.delegate configurationSheetDidComplete];
    }
}

- (IBAction)importBackPushed:(id)sender
{
    [self showContactImportView];
}

- (IBAction)importContinuePushed:(id)sender
{
    if (self.delegate != nil) {
        [self.delegate loginPushedUsername:nil password:nil];
    }
}

@end
