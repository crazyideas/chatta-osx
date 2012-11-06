//
//  DetailViewController.m
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import "DetailViewController.h"

#import "CKContact.h"
#import "DetailViewCacheItem.h"

#import "NSString+CKAdditions.h"


@implementation DetailViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.detailView       = [[DetailView alloc] initWithFrame:NSZeroRect];
        self.textStorageCache = [[NSMutableDictionary alloc] init];
        
        [self setEnabled:NO];

        [self.detailView setAutoresizesSubviews:YES];
        [self.detailView setAutoresizingMask:NSViewMinXMargin | NSViewMaxXMargin |
            NSViewMinYMargin | NSViewMaxYMargin];

        [self.detailView.textField setTarget:self];
        [self.detailView.textField setAction:@selector(newMessageAction:)];
        [self.detailView.textField setDelegate:self];
        
        // needed to propogate first responder information up
        [self.detailView.textView setDelegate:self];
                
        self.view = self.detailView;
    }
    return self;
}

- (void)appendNewMessage:(CKMessage *)message forContact:(CKContact *)contact;
{
    NSAttributedString *newMessageAttrString = [self.detailView attributedStringForMessage:message];
    
    // update cache
    DetailViewCacheItem *cacheItem = [self.textStorageCache objectForKey:contact.displayName];
    [cacheItem.textStorage appendAttributedString:newMessageAttrString];
    cacheItem.itemCount++;
    [self.textStorageCache setObject:cacheItem forKey:contact.displayName];
    
    // update interface
    [self.detailView appendMessageView:newMessageAttrString];
}

- (void)updateTextFieldPlaceholderText:(CKContact *)contact
{
    // not connected
    if (self.enabled == NO) {
        [self.detailView.textField setEnabled:NO];
        [self.detailView.textField.cell setPlaceholderString:@"Sign in to chat..."];
        return;
    }
    
    // no contact selected
    if (contact == nil) {
        [self.detailView.textField setEnabled:NO];
        [self.detailView.textField.cell setPlaceholderString:@"Select a contact to chat..."];
        return;
    }
    
    // contact selected
    switch (contact.connectionState) {
        case ContactStateOnline:
        {
            if (contact.jabberIdentifier == nil) {
                [self.detailView.textField setEnabled:NO];
                [self.detailView.textField.cell setPlaceholderString:@"Update contact email address to chat..."];
                break;
            }
            [self.detailView.textField setEnabled:YES];
            [self.detailView.textField.cell setPlaceholderString:@"Google Talk..."];
            break;
        }
        case ContactStateOffline:
        {
            if (contact.phoneNumber == nil) {
                [self.detailView.textField setEnabled:NO];
                [self.detailView.textField.cell setPlaceholderString:@"Update contact phone number to chat..."];
                break;
            }
            [self.detailView.textField setEnabled:YES];
            [self.detailView.textField.cell setPlaceholderString:@"Google Voice..."];
            break;
        }
        case ContactStateIndeterminate:
        {
            [self.detailView.textField setEnabled:NO];
            [self.detailView.textField.cell setPlaceholderString:@"Sign in to chat..."];
            break;
        }
        default:
            break;
    }
}

#pragma mark - Properties

- (void)setEnabled:(BOOL)enabled
{
    [self.detailView.textField setEnabled:self.detailView.textField.isEnabled & enabled];
    
    _enabled = enabled;
}

- (void)setContact:(CKContact *)contact
{
    [self.detailView clearMessageView];
    [self updateTextFieldPlaceholderText:contact];
    
    if (contact == nil) {
        return;
    }
    
    // update text view with actual conversation
    DetailViewCacheItem *cacheItem = [self.textStorageCache objectForKey:contact.displayName];
    if (cacheItem == nil) {
        cacheItem = [[DetailViewCacheItem alloc] init];
        for (CKMessage *message in contact.messages) {
            [cacheItem.textStorage appendAttributedString:[self.detailView attributedStringForMessage:message]];
            cacheItem.itemCount++;
        }
        [self.textStorageCache setObject:cacheItem forKey:contact.displayName];
    }
    else {
        if (cacheItem.itemCount != contact.messages.count) {
            for (NSUInteger i = cacheItem.itemCount; i < contact.messages.count; i++) {
                CKMessage *tmsg = [contact.messages objectAtIndex:i];
                [cacheItem.textStorage appendAttributedString:[self.detailView attributedStringForMessage:tmsg]];
                cacheItem.itemCount++;
            }
            [self.textStorageCache setObject:cacheItem forKey:contact.displayName];
        }
    }
    
    [self.detailView appendMessageView:cacheItem.textStorage];
    
    _contact = contact;
}

#pragma mark - Actions

- (void)newMessageAction:(id)sender
{
    NSTextField *textField = sender;
    
    if ([textField.stringValue isEqualToString:@""]) {
        return;
    }
    
    if (self.delegate != nil) {
        NSString *trimmedString = [textField.stringValue stringByRemovingWhitespaceNewlineChars];
        [self.delegate sendNewMessage:trimmedString toContact:self.contact];
    }
    
    textField.stringValue = @"";
}

#pragma mark - NSTextField Delegates

- (BOOL)control:(NSControl *)control textShouldBeginEditing:(NSText *)fieldEditor
{
    NSTextView *textView = (NSTextView *)fieldEditor;
    [textView setContinuousSpellCheckingEnabled:YES];
    return YES;
}

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor
{
    NSTextView *textView = (NSTextView *)fieldEditor;
    [textView setContinuousSpellCheckingEnabled:NO];
    return YES;
}

#pragma mark - NSTextView Delegates

- (void)textViewDidChangeSelection:(NSNotification *)notification
{
    if (self.delegate != nil) {
        [self.delegate makeDetailViewFirstResponder];
    }
}

@end
