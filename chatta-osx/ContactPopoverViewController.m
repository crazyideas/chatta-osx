//
//  ContactPopoverViewController.m
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import "ContactPopoverViewController.h"

@implementation ContactPopoverViewController

@synthesize popoverType           = _popoverType;
@synthesize contact               = _contact;
@synthesize phoneNumberFormatter  = _phoneNumberFormatter;
@synthesize emailAddressFormatter = _emailAddressFormatter;
@synthesize delegate              = _delegate;
@synthesize titleTextField        = _titleTextField;
@synthesize leftButton            = _leftButton;
@synthesize rightButton           = _rightButton;
@synthesize nameTextField         = _nameTextField;
@synthesize emailTextField        = _emailTextField;
@synthesize phoneTextField        = _phoneTextField;

#pragma mark - Properties

- (void)setContact:(id)contact
{    
    self.nameTextField.stringValue  = nil;
    self.emailTextField.stringValue = nil;
    self.phoneTextField.stringValue = nil;
    
    _contact = contact;
}

- (void)setPopoverType:(PopoverType)popoverType
{
    switch (popoverType) {
        case PopoverTypeAddContact:
        {
            self.titleTextField.stringValue = @"Add Contact";
            self.leftButton.title  = @"Cancel";
            self.rightButton.title = @"Add";
            break;
        }
        case PopoverTypeUpdateContact:
        {
            self.titleTextField.stringValue = @"Update Contact";
            self.leftButton.title  = @"Cancel";
            self.rightButton.title = @"Update";
            break;
        }
        default:
        {
            break;   
        }
    }

    _popoverType = popoverType;
}

#pragma mark - Init Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        self.phoneNumberFormatter  = [[PhoneNumberFormatter alloc] init];
        self.emailAddressFormatter = [[EmailAddressFormatter alloc] init];
    }
    
    return self;
}

- (void)awakeFromNib
{
    self.nameTextField.delegate  = self;
    self.emailTextField.delegate = self;
    self.phoneTextField.delegate = self;
    
    self.phoneTextField.formatter = self.phoneNumberFormatter;
    self.emailTextField.formatter = self.emailAddressFormatter;
    
    nameValid  = NO;
    emailValid = NO;
    phoneValid = NO;
}

#pragma mark - Button Actions

- (IBAction)rightButtonPushed:(id)sender
{
    switch (self.popoverType) {
        case PopoverTypeAddContact:
        {
            if (self.delegate != nil) {                
                [self.delegate addContactWithName:self.nameTextField.stringValue 
                                            email:self.emailTextField.stringValue 
                                            phone:self.phoneTextField.stringValue];
                
                [self.delegate closePopover];
            }
            break;
        }
        case PopoverTypeUpdateContact:
        {
            if (self.delegate != nil) {                
                [self.delegate updateContact:self.contact 
                                    withName:self.nameTextField.stringValue 
                                       email:self.emailTextField.stringValue 
                                       phone:self.phoneTextField.stringValue];
                
                [self.delegate closePopover];
            }
            break;
        }
        default:
        {
            break;   
        }
    }
}

- (IBAction)leftButtonPushed:(id)sender
{
    if (self.delegate != nil) {
        [self.delegate closePopover];
    }
}

#pragma mark - NSTextFieldDelegate

- (void)controlTextDidChange:(NSNotification *)object
{
    NSTextField *textField = (NSTextField *)object.object;

    if ([textField.identifier isEqualToString:@"nameField"]) {
        nameValid = (textField.stringValue.length > 0) ? YES : NO;
    }
    
    if ([textField.identifier isEqualToString:@"emailField"]) {
        emailValid = [EmailAddressFormatter isValidEmailAddress:textField.stringValue];
    }
    
    if ([textField.identifier isEqualToString:@"phoneField"]) {
        phoneValid = [PhoneNumberFormatter isValidPhoneNumber:textField.stringValue];
    }

    if (nameValid && emailValid && phoneValid) {
        [self.rightButton setEnabled:YES];
    } else {
        [self.rightButton setEnabled:NO];
    }
}

#pragma mark - NSPopover Delegates

- (void)popoverWillShow:(NSNotification *)notification
{
    switch (self.popoverType) {
        case PopoverTypeAddContact:
        {
            self.nameTextField.stringValue  = @"";
            self.phoneTextField.stringValue = @"";
            self.emailTextField.stringValue = @"";
            [self.rightButton setEnabled:NO];
            break;
        }
        case PopoverTypeUpdateContact:
        {
            // load contact information into fields
            [self.rightButton setEnabled:NO];
        }
        default:
        {
            break;
        }
    }
}

- (void)popoverDidShow:(NSNotification *)notification
{
    
}

- (void)popoverWillClose:(NSNotification *)notification
{
}

- (void)popoverDidClose:(NSNotification *)notification
{
}


@end