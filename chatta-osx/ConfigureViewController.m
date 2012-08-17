//
//  ConfigureViewController.m
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import "ConfigureViewController.h"
#import "CKEmailAddressFormatter.h"
#import "CKProgressIndicator.h"
#import "CKView.h"

@implementation ConfigureViewController

@synthesize delegate               = _delegate;
@synthesize emailAddressFormatter  = _emailAddressFormatter;
@synthesize chattaTextField        = _chattaTextField;
@synthesize usernameTextField      = _usernameTextField;
@synthesize passwordTextField      = _passwordTextField;
@synthesize loginProgressIndicator = _loginProgressIndicator;
@synthesize firstCancelButton      = _firstCancelButton;
@synthesize firstPreviousButton    = _firstPreviousPressed;
@synthesize firstNextButton        = _firstNextButton;
@synthesize errorLabel = _errorLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.emailAddressFormatter = [[CKEmailAddressFormatter alloc] init];
    }
    
    return self;
}

- (void)awakeFromNib
{    
    self.chattaTextField.font = [NSFont fontWithName:@"Cookie-Regular" size:60];
    self.chattaTextField.textColor = [NSColor colorWithCalibratedRed:90/255.0 green:67/255.0 blue:210/255.0 alpha:1.0];
    
    self.errorLabel.stringValue = @"Unable to login, try again?";
    self.errorLabel.textColor = [NSColor redColor];
    
    [self showErrorLabel:NO];
    
    self.passwordTextField.delegate = self;
    self.usernameTextField.delegate = self;
    self.usernameTextField.formatter = self.emailAddressFormatter;
    
    CKView *configureView = (CKView *)self.view;
    configureView.backgroundImage = [NSImage imageNamed:@"light_texture_2.png"];
    configureView.backgroundImageAlpha = 0.95;
    configureView.needsDisplay = YES;
    
    [self configureSheetWillOpen];
}

- (void)loginInProgress
{
    self.loginProgressIndicator.usesThreadedAnimation = YES;
    [self.loginProgressIndicator startAnimation:self];
    
    [self showErrorLabel:NO];
    
    [self.usernameTextField setEnabled:NO];
    [self.passwordTextField setEnabled:NO];
    [self.firstNextButton setEnabled:NO];
}

- (void)loginStopped
{
    [self showErrorLabel:YES];
    [self.loginProgressIndicator stopAnimation:self];
    [self.usernameTextField setEnabled:YES];
    [self.passwordTextField setEnabled:YES];
    [self.firstNextButton setEnabled:YES];
}

- (void)configureSheetWillOpen
{
    [self showErrorLabel:NO];
    [self validateFieldsAndUpdateButtons];
    [self.usernameTextField becomeFirstResponder];
}

- (void)configureSheetWillClose
{
    [self loginStopped];
    self.usernameTextField.stringValue = @"";
    self.passwordTextField.stringValue = @"";
    [self.usernameTextField resignFirstResponder];
}

- (void)validateFieldsAndUpdateButtons
{
    NSString *usernameString = self.usernameTextField.stringValue;
    NSString *passwordString = self.passwordTextField.stringValue;
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
    
    [self.firstNextButton setEnabled:usernameValid && passwordValid];
    [self.firstPreviousButton setEnabled:NO];
}

- (void)showErrorLabel:(BOOL)showErrorLabel
{
    [self.loginProgressIndicator setHidden:showErrorLabel];
    [self.errorLabel setHidden:!showErrorLabel];
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
    
    [self loginInProgress];
}

- (IBAction)firstCancelPushed:(id)sender
{
    if (self.delegate != nil) {
        // if we are currently logging in, cancel just stops the login
        if (self.loginProgressIndicator.inProgress == YES) {
            [self loginStopped];
            [self.delegate cancelChattaLogin];
            return;
        }
        
        // remove the configuration sheet
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
