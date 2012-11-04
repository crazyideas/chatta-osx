//
//  PopoverViewController.m
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import "PopoverViewController.h"
#import "PopoverView.h"

#import "CKPhoneNumberFormatter.h"

@implementation PopoverViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.popoverView = [[PopoverView alloc] initWithFrame:NSMakeRect(0, 0, 320, 185)];
        
        self.view = self.popoverView;
        [self.view setAutoresizesSubviews:YES];
        [self.view setAutoresizingMask:NSViewMinXMargin | NSViewMaxXMargin |
            NSViewMinYMargin | NSViewMaxYMargin];
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

@end
