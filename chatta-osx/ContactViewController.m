//
//  PopoverViewController.m
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import "ContactViewController.h"
#import "ContactView.h"

#import "CKPhoneNumberFormatter.h"
#import "CKEmailAddressFormatter.h"
#import "CKContact.h"

@implementation ContactViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.popover     = [[NSPopover alloc] init];
        self.contactView = [[ContactView alloc] initWithFrame:NSMakeRect(0, 0, 320, 185)];
        
        self.phoneNumberFormatter  = [[CKPhoneNumberFormatter alloc] init];
        self.emailAddressFormatter = [[CKEmailAddressFormatter alloc] init];

        [self.popover setContentViewController:self];
        [self.popover setAnimates:YES];
        [self.popover setBehavior:NSPopoverBehaviorTransient];
        [self.popover setDelegate:self];
        
        [self.contactView.rightButton setTarget:self];
        [self.contactView.rightButton setAction:@selector(rightButtonAction:)];
        
        [self.contactView.leftButton setTarget:self];
        [self.contactView.leftButton setAction:@selector(leftButtonAction:)];

        [self.contactView.nameTextField setDelegate:self];
        [self.contactView.nameTextField setTarget:self];
        [self.contactView.nameTextField setAction:@selector(rightButtonAction:)];

        [self.contactView.phoneTextField setDelegate:self];
        [self.contactView.phoneTextField setTarget:self];
        [self.contactView.phoneTextField setAction:@selector(rightButtonAction:)];
        [self.contactView.phoneTextField setFormatter:self.phoneNumberFormatter];
        
        [self.contactView.emailTextField setDelegate:self];
        [self.contactView.emailTextField setTarget:self];
        [self.contactView.emailTextField setAction:@selector(rightButtonAction:)];
        
        [self.contactView setAutoresizesSubviews:YES];
        [self.contactView setAutoresizingMask:NSViewMinXMargin | NSViewMaxXMargin |
            NSViewMinYMargin | NSViewMaxYMargin];
        
        self.view = self.contactView;
    }
    return self;
}

#pragma mark - Properties

- (void)setContact:(CKContact *)contact
{
    self.contactView.nameTextField.stringValue  = (contact.displayName)      ? contact.displayName      : @"";
    self.contactView.emailTextField.stringValue = (contact.jabberIdentifier) ? contact.jabberIdentifier : @"";
    self.contactView.phoneTextField.stringValue =
    [CKPhoneNumberFormatter phoneNumberInDisplayFormat:contact.phoneNumber];
    
    _contact = contact;
}

- (void)setContactViewType:(ContactViewType)contactViewType
{
    [self.contactView setContactViewType:contactViewType];
    _contactViewType = contactViewType;
}


#pragma mark - Button Actions

- (void)rightButtonAction:(id)sender
{
    CKDebug(@"[+] PopoverViewController: rightButtonAction");
    
    if (self.contactView.rightButton.isEnabled == NO) {
        return;
    }
    
    NSString *name  = self.contactView.nameTextField.stringValue;
    NSString *phone = self.contactView.phoneTextField.stringValue;
    NSString *email = self.contactView.emailTextField.stringValue;
    
    NSString *servicePhoneNumber  = [CKPhoneNumberFormatter phoneNumberInServiceFormat:phone];
    
    switch (self.contactViewType) {
        case ContactViewTypeAddContact:
        {
            if (self.delegate != nil) {
                [self.delegate addContactWithName:name email:email phone:servicePhoneNumber];
            }
            break;
        }
        case ContactViewTypeUpdateContact:
        {
            if (self.delegate != nil) {
                [self.delegate updateContact:self.contact withName:name email:email phone:servicePhoneNumber];
            }
            break;
        }
        default:
        {
            break;   
        }
    }
    
    [self.popover close];
}

- (void)leftButtonAction:(id)sender
{
    CKDebug(@"[+] PopoverViewController: leftButtonAction");
    [self.popover close];
}


#pragma mark - NSTextFieldDelegate

- (void)controlTextDidChange:(NSNotification *)object
{
    NSString *contactEmailAddress = self.contactView.emailTextField.stringValue;
    
    BOOL nameValid  = NO;
    BOOL emailValid = NO;
    BOOL phoneValid = NO;
    
    nameValid = (self.contactView.nameTextField.stringValue.length > 0) ? YES : NO;
    emailValid = [CKEmailAddressFormatter isValidEmailAddress:contactEmailAddress];
    if ([contactEmailAddress isEqualToString:@""]) {
        emailValid = YES;
    }
    
    phoneValid = [CKPhoneNumberFormatter isValidPhoneNumber:self.contactView.phoneTextField.stringValue];
    if ([self.contactView.phoneTextField.stringValue isEqualToString:@""]) {
        phoneValid = YES;
    }
    
    if (nameValid && emailValid && phoneValid) {
        [self.contactView.rightButton setEnabled:YES];
    } else {
        [self.contactView.rightButton setEnabled:NO];
    }
}

#pragma mark - NSPopover Delegates

- (void)popoverWillShow:(NSNotification *)notification
{
    switch (self.contactViewType) {
        case ContactViewTypeAddContact:
        {
            [self.contactView.nameTextField setStringValue:@""];
            [self.contactView.phoneTextField setStringValue:@""];
            [self.contactView.emailTextField setStringValue:@""];
            [self.contactView.rightButton setEnabled:NO];
            break;
        }
        case ContactViewTypeUpdateContact:
        {
            [self.contactView.rightButton setEnabled:NO];
        }
        default:
        {
            break;
        }
    }
}

- (void)popoverWillClose:(NSNotification *)notification
{
    CKDebug(@"[+] PopoverViewController, popoverWillClose");
    if (self.delegate != nil) {
        [self.delegate popoverWillClose:self];
    }
}

@end
