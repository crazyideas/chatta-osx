//
//  PopoverViewController.m
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import "PopoverViewController.h"
#import "PopoverView.h"

#import "CKPhoneNumberFormatter.h"
#import "CKEmailAddressFormatter.h"
#import "CKContact.h"

@implementation PopoverViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.popover     = [[NSPopover alloc] init];
        self.popoverView = [[PopoverView alloc] initWithFrame:NSMakeRect(0, 0, 320, 185)];
        
        self.phoneNumberFormatter  = [[CKPhoneNumberFormatter alloc] init];
        self.emailAddressFormatter = [[CKEmailAddressFormatter alloc] init];

        [self.popover setContentViewController:self];
        [self.popover setAnimates:YES];
        [self.popover setBehavior:NSPopoverBehaviorTransient];
        [self.popover setDelegate:self];
        
        [self.popoverView.rightButton setTarget:self];
        [self.popoverView.rightButton setAction:@selector(rightButtonAction:)];
        
        [self.popoverView.leftButton setTarget:self];
        [self.popoverView.leftButton setAction:@selector(leftButtonAction:)];

        [self.popoverView.nameTextField setDelegate:self];
        [self.popoverView.nameTextField setTarget:self];
        [self.popoverView.nameTextField setAction:@selector(rightButtonAction:)];

        [self.popoverView.phoneTextField setDelegate:self];
        [self.popoverView.phoneTextField setTarget:self];
        [self.popoverView.phoneTextField setAction:@selector(rightButtonAction:)];
        [self.popoverView.phoneTextField setFormatter:self.phoneNumberFormatter];
        
        [self.popoverView.emailTextField setDelegate:self];
        [self.popoverView.emailTextField setTarget:self];
        [self.popoverView.emailTextField setAction:@selector(rightButtonAction:)];
        
        [self.popoverView setAutoresizesSubviews:YES];
        [self.popoverView setAutoresizingMask:NSViewMinXMargin | NSViewMaxXMargin |
            NSViewMinYMargin | NSViewMaxYMargin];
        
        self.view = self.popoverView;
    }
    return self;
}

#pragma mark - Properties

- (void)setContact:(CKContact *)contact
{
    self.popoverView.nameTextField.stringValue  = (contact.displayName)      ? contact.displayName      : @"";
    self.popoverView.emailTextField.stringValue = (contact.jabberIdentifier) ? contact.jabberIdentifier : @"";
    self.popoverView.phoneTextField.stringValue =
    [CKPhoneNumberFormatter phoneNumberInDisplayFormat:contact.phoneNumber];
    
    _contact = contact;
}

- (void)setPopoverType:(PopoverType)popoverType
{
    [self.popoverView setPopoverType:popoverType];
    _popoverType = popoverType;
}


#pragma mark - Button Actions

- (void)rightButtonAction:(id)sender
{
    CKDebug(@"[+] PopoverViewController: rightButtonAction");
    
    if (self.popoverView.rightButton.isEnabled == NO) {
        return;
    }
    
    NSString *name  = self.popoverView.nameTextField.stringValue;
    NSString *phone = self.popoverView.phoneTextField.stringValue;
    NSString *email = self.popoverView.emailTextField.stringValue;
    
    NSString *servicePhoneNumber  = [CKPhoneNumberFormatter phoneNumberInServiceFormat:phone];
    
    switch (self.popoverType) {
        case PopoverTypeAddContact:
        {
            if (self.delegate != nil) {
                [self.delegate addContactWithName:name email:email phone:servicePhoneNumber];
            }
            break;
        }
        case PopoverTypeUpdateContact:
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
    NSString *contactEmailAddress = self.popoverView.emailTextField.stringValue;
    
    BOOL nameValid  = NO;
    BOOL emailValid = NO;
    BOOL phoneValid = NO;
    
    nameValid = (self.popoverView.nameTextField.stringValue.length > 0) ? YES : NO;
    emailValid = [CKEmailAddressFormatter isValidEmailAddress:contactEmailAddress];
    if ([contactEmailAddress isEqualToString:@""]) {
        emailValid = YES;
    }
    
    phoneValid = [CKPhoneNumberFormatter isValidPhoneNumber:self.popoverView.phoneTextField.stringValue];
    if ([self.popoverView.phoneTextField.stringValue isEqualToString:@""]) {
        phoneValid = YES;
    }
    
    if (nameValid && emailValid && phoneValid) {
        [self.popoverView.rightButton setEnabled:YES];
    } else {
        [self.popoverView.rightButton setEnabled:NO];
    }
}

#pragma mark - NSPopover Delegates

- (void)popoverWillShow:(NSNotification *)notification
{
    switch (self.popoverType) {
        case PopoverTypeAddContact:
        {
            [self.popoverView.nameTextField setStringValue:@""];
            [self.popoverView.phoneTextField setStringValue:@""];
            [self.popoverView.emailTextField setStringValue:@""];
            [self.popoverView.rightButton setEnabled:NO];
            break;
        }
        case PopoverTypeUpdateContact:
        {
            [self.popoverView.rightButton setEnabled:NO];
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
