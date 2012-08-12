//
//  ContactPopoverViewController.m
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import "ContactPopoverViewController.h"

@implementation ContactPopoverViewController

- (NSString *)emailFromTokenField
{
    NSArray *tokens = self.emailTokenField.objectValue;
    
    if (tokens == nil || tokens.count < 1) {
        return @"";
    }
    
    return [self.emailTokenField.objectValue objectAtIndex:0];
}

#pragma mark - Properties

- (void)setContact:(CKContact *)contact
{
    self.nameTextField.stringValue   = (contact.displayName)      ? contact.displayName      : @"";
    self.emailTokenField.objectValue = (contact.jabberIdentifier) ? contact.jabberIdentifier : @"";
    self.phoneTextField.stringValue  =
        [CKPhoneNumberFormatter phoneNumberInDisplayFormat:contact.phoneNumber];
    
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
        self.phoneNumberFormatter  = [[CKPhoneNumberFormatter alloc] init];
        self.emailAddressFormatter = [[CKEmailAddressFormatter alloc] init];
    }
    
    return self;
}

- (void)awakeFromNib
{
    self.nameTextField.delegate   = self;
    //self.emailTextField.delegate  = self;
    self.phoneTextField.delegate  = self;
    self.emailTokenField.delegate = self;
    
    self.emailTokenField.tokenStyle = NSPlainTextTokenStyle;
    
    self.phoneTextField.formatter = self.phoneNumberFormatter;
    //self.emailTokenField.formatter = self.emailAddressFormatter;
    //self.emailTextField.formatter = self.emailAddressFormatter;
    
    self.titleTextField.textColor = [NSColor grayColor];
}

#pragma mark - Button Actions

- (IBAction)rightButtonPushed:(id)sender
{
    NSString *servicePhoneNumber =
        [CKPhoneNumberFormatter phoneNumberInServiceFormat:self.phoneTextField.stringValue];
    NSString *contactEmailAddress = [self emailFromTokenField];

    switch (self.popoverType) {
        case PopoverTypeAddContact:
        {
            if (self.delegate != nil) {
                [self.delegate addContactWithName:self.nameTextField.stringValue 
                                            email:contactEmailAddress 
                                            phone:servicePhoneNumber];
                
                [self.delegate closePopover];
            }
            break;
        }
        case PopoverTypeUpdateContact:
        {
            if (self.delegate != nil) {                
                [self.delegate updateContact:self.contact 
                                    withName:self.nameTextField.stringValue 
                                       email:contactEmailAddress 
                                       phone:servicePhoneNumber];
                
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
    NSString *contactEmailAddress = [self emailFromTokenField];

    BOOL nameValid  = NO;
    BOOL emailValid = NO;
    BOOL phoneValid = NO;
    
    nameValid = (self.nameTextField.stringValue.length > 0) ? YES : NO;
    emailValid = [CKEmailAddressFormatter isValidEmailAddress:contactEmailAddress];
    phoneValid = [CKPhoneNumberFormatter isValidPhoneNumber:self.phoneTextField.stringValue];
    
    if (nameValid && emailValid && phoneValid) {
        [self.rightButton setEnabled:YES];
    } else {
        [self.rightButton setEnabled:NO];
    }
}

#pragma mark - NSTokenField Delegates

- (NSArray *)tokenField:(NSTokenField *)tokenField completionsForSubstring:(NSString *)substring
           indexOfToken:(NSInteger)tokenIndex indexOfSelectedItem:(NSInteger *)selectedIndex
{
    CKRoster *xmppRoster = [self.chattaKit requestXmppRoster];
    if (xmppRoster == nil) {
        return nil;
    }
    
    NSUInteger rosterSize = xmppRoster.roster.count;
    NSMutableArray *rosterIdentifiers = [[NSMutableArray alloc] initWithCapacity:rosterSize];
    for (CKRosterItem *rosterItem in xmppRoster.roster) {
        [rosterIdentifiers addObject:rosterItem.bareJabberIdentifier];
    }
    
    NSArray *matchingItems = [rosterIdentifiers filteredArrayUsingPredicate:
        [NSPredicate predicateWithFormat:@"SELF beginswith[cd] %@", substring]];
    
    return matchingItems;
}

#pragma mark - NSPopover Delegates

- (void)popoverWillShow:(NSNotification *)notification
{
    switch (self.popoverType) {
        case PopoverTypeAddContact:
        {
            self.nameTextField.stringValue   = @"";
            self.phoneTextField.stringValue  = @"";
            self.emailTokenField.objectValue = @"";
            [self.rightButton setEnabled:NO];
            break;
        }
        case PopoverTypeUpdateContact:
        {
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
    return;
}

- (void)popoverWillClose:(NSNotification *)notification
{
    return;
}

- (void)popoverDidClose:(NSNotification *)notification
{
    return;
}


@end
