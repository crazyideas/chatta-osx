//
//  DetailViewController.m
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import "DetailViewController.h"
#import "DetailViewCacheItem.h"
#import "NSString+CKAdditions.h"
#import "CKTextView.h"
#import "CKScrollView.h"
#import "CKContact.h"
#import "CKMessage.h"

@implementation DetailViewController

- (void)setEnabled:(BOOL)enabled
{
    if (enabled == YES) {
        [self.messagesInputTextField.cell setPlaceholderString:@"Type message here..."];
    } else {
        [self.messagesInputTextField.cell setPlaceholderString:@"Login to send messages..."];
    }
    
    [self.messagesTextView setEnabled:enabled];
    [self.messagesInputTextField setEnabled:enabled];
    _enabled = enabled;
}

- (void)setContact:(CKContact *)contact
{
    [self clearDetailView];

    if (contact == nil) {
        return;
    }
    
    DetailViewCacheItem *cacheItem = [self.textStorageCache objectForKey:contact.displayName];
    if (cacheItem == nil) {
        cacheItem = [[DetailViewCacheItem alloc] init];
        for (CKMessage *message in contact.messages) {
            [cacheItem.textStorage appendAttributedString:[self attributedStringForMessage:message]];
            cacheItem.itemCount++;
        }
        [self.textStorageCache setObject:cacheItem forKey:contact.displayName];
    }
    else {
        if (cacheItem.itemCount != contact.messages.count) {
            for (NSUInteger i = cacheItem.itemCount; i < contact.messages.count; i++) {
                CKMessage *tmsg = [contact.messages objectAtIndex:i];
                [cacheItem.textStorage appendAttributedString:[self attributedStringForMessage:tmsg]];
                cacheItem.itemCount++;
            }
            [self.textStorageCache setObject:cacheItem forKey:contact.displayName];
        }
    }
    
    [self appendAttributedStringToDetailView:cacheItem.textStorage];

    _contact = contact;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.textStorageCache = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)awakeFromNib
{
    self.messagesInputTextField.delegate = self;
    self.messagesTextView.textContainerInset = NSMakeSize(1.0, 1.0);
}

- (IBAction)newMessageEntered:(id)sender 
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

- (NSAttributedString *)attributedStringForMessage:(CKMessage *)message
{
    NSMutableAttributedString *attrString =
        [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:
        @"[%@] %@: %@\n", message.timestampString, message.contact.displayName, message.text]];

    NSRange boldRange = [attrString.string rangeOfString:message.contact.displayName];
    NSRange greyRange = [attrString.string rangeOfString:
                         [NSString stringWithFormat:@"[%@]", message.timestampString]];
    
    [attrString beginEditing];
    [attrString addAttribute:NSFontAttributeName
                       value:[NSFont fontWithName:@"Helvetica" size:14]
                       range:NSMakeRange(0, [attrString length])];
    [attrString addAttribute:NSFontAttributeName
                       value:[NSFont fontWithName:@"Helvetica-Bold" size:14]
                       range:boldRange];
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:[NSColor disabledControlTextColor]
                       range:greyRange];
    [attrString endEditing];
    
    return attrString;
}

- (void)clearDetailView
{
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        NSAttributedString *blankAttributedString = [[NSAttributedString alloc] initWithString:@""];
        self.messagesInputTextField.stringValue = @"";
        [self.messagesTextView.textStorage setAttributedString:blankAttributedString];
        [self.messagesTextView setNeedsDisplay:YES];
        [self.scrollView scrollToBottom];
    });
}

- (void)appendAttributedStringToDetailView:(NSAttributedString *)attributedString
{
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [self.messagesTextView.textStorage appendAttributedString:attributedString];

        // scroll to bottom, for some reason [self.scrollView scrollToBottom] doesn't like
        // huge lines, so for those cases use, [self.messagesTextView scrollRangeToVisible:range]
        if (attributedString.length > 200) {
            NSRange range = NSMakeRange(self.messagesTextView.attributedString.length, 0);
            [self.messagesTextView scrollRangeToVisible:range];
        } else {
            [self.scrollView scrollToBottom];
        }
        [self.messagesTextView setNeedsDisplay:YES];
    });
}

- (void)appendNewMessage:(CKMessage *)message forContact:(CKContact *)contact
{
    NSAttributedString *newMessageAttrString = [self attributedStringForMessage:message];
    
    // update cache
    DetailViewCacheItem *cacheItem = [self.textStorageCache objectForKey:contact.displayName];
    [cacheItem.textStorage appendAttributedString:newMessageAttrString];
    cacheItem.itemCount++;
    [self.textStorageCache setObject:cacheItem forKey:contact.displayName];
    
    // update interface
    [self appendAttributedStringToDetailView:newMessageAttrString];
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

@end
