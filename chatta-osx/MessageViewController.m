//
//  MessageViewController.m
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import "MessageViewController.h"

#import "CKContact.h"
#import "CKContactList.h"

#import "CKEmailAddressFormatter.h"
#import "CKPhoneNumberFormatter.h"

#import "NSString+CKAdditions.h"

@implementation MessageViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.popover     = [[NSPopover alloc] init];
        self.messageView = [[MessageView alloc] initWithFrame:NSMakeRect(0, 0, 320, 210)];
        
        [self.popover setContentViewController:self];
        [self.popover setAnimates:YES];
        [self.popover setBehavior:NSPopoverBehaviorTransient];
        [self.popover setDelegate:self];
        
        [self.messageView.sendButton setTarget:self];
        [self.messageView.sendButton setAction:@selector(sendAction:)];
        
        [self.messageView.messageTextField setDelegate:self];
        [self.messageView.serviceTextField setDelegate:self];
        
        [self.messageView.messageTextField setTarget:self];
        [self.messageView.messageTextField setAction:@selector(sendAction:)];
        
        self.view = self.messageView;
    }
    return self;
}

#pragma mark - NSPopover Delegates

- (void)popoverWillShow:(NSNotification *)notification
{
    CKDebug(@"[+] MessageViewController, popoverWillShow");
}

- (void)popoverWillClose:(NSNotification *)notification
{
    CKDebug(@"[+] MessageViewController, popoverWillClose");
    
    [self.messageView.serviceTextField setStringValue:@""];
    [self.messageView.messageTextField setStringValue:@""];
    
    if (self.delegate != nil) {
        [self.delegate popoverWillClose:self];
    }
}

#pragma mark - NSTextFieldDelegate

- (void)controlTextDidChange:(NSNotification *)object
{
    BOOL serviceFieldValid = NO;
    BOOL messageFieldValid = NO;
    
    switch (self.messageView.messageViewState) {
        case MessageViewStateInstantService:
        {
            NSString *contactEmailAddress = self.messageView.serviceTextField.stringValue;
            serviceFieldValid = [CKEmailAddressFormatter isValidEmailAddress:contactEmailAddress];
           
            break;
        }
        case MessageViewStateTextService:
        {
            serviceFieldValid = [CKPhoneNumberFormatter isValidPhoneNumber:
                self.messageView.serviceTextField.stringValue];
            break;
        }
        default:
        {
            break;
        }
    }
    
    NSString *messageString = [self.messageView.messageTextField.stringValue stringByRemovingWhitespaceNewlineChars];
    if ([messageString isEqualToString:@""]) {
        messageFieldValid = NO;
    } else {
        messageFieldValid = YES;
    }
  
    if (serviceFieldValid == YES && messageFieldValid == YES) {
        [self.messageView.sendButton setEnabled:YES];
    } else {
        [self.messageView.sendButton setEnabled:NO];
    }
}

#pragma mark - Actions

- (void)sendAction:(id)sender
{
    CKContact *contact = nil;
    BOOL createNewContact = NO;
    NSString *serviceString = self.messageView.serviceTextField.stringValue;
    NSString *messageString = self.messageView.messageTextField.stringValue;
    
    // see if contact exists, if not, create contact
    if (self.messageView.messageViewState == MessageViewStateInstantService) {
        contact = [[CKContactList sharedInstance] contactWithJabberIdentifier:serviceString];
        
        if (contact == nil) {
            contact = [[CKContact alloc] initWithJabberIdentifier:serviceString andDisplayName:serviceString andPhoneNumber:nil andContactState:ContactStateOnline];
            createNewContact = YES;
        }
    } else {
        NSString *phoneNumberServiceFormat = [CKPhoneNumberFormatter phoneNumberInServiceFormat:serviceString];
        contact = [[CKContactList sharedInstance] contactWithPhoneNumber:phoneNumberServiceFormat];
        
        if (contact == nil) {
            contact = [[CKContact alloc] initWithJabberIdentifier:nil andDisplayName:serviceString andPhoneNumber:phoneNumberServiceFormat andContactState:ContactStateOffline];
            createNewContact = YES;
        }
    }
    
    // send message
    if (self.delegate != nil) {
        NSString *trimmedString = [messageString stringByRemovingWhitespaceNewlineChars];
        [self.delegate sendNewMessage:trimmedString toContact:contact newContact:createNewContact];
    }
    
    [self.popover close];
}

@end
