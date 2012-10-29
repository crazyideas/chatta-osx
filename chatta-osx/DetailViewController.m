//
//  DetailViewController.m
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import "DetailViewController.h"
#import "DetailViewCacheItem.h"
#import "CKContact.h"

@implementation DetailViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.detailView = [[DetailView alloc] initWithFrame:NSZeroRect];
        [self.detailView setAutoresizesSubviews:YES];
        [self.detailView setAutoresizingMask:NSViewMinXMargin | NSViewMaxXMargin |
            NSViewMinYMargin | NSViewMaxYMargin];
        self.detailView.delegate = self;

        self.textStorageCache = [[NSMutableDictionary alloc] init];

        // needed to propogate first responder information up
        self.detailView.textView.delegate = self;

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

#pragma mark - Properties

- (void)setContact:(CKContact *)contact
{
    [self.detailView clearMessageView];
    
    if (contact == nil) {
        return;
    }
    
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

#pragma mark - DetailView Delegates

- (void)newMessageActionKeyUp:(id)sender message:(NSString *)message
{
    if (self.delegate != nil) {
        [self.delegate sendNewMessage:message toContact:self.contact];
    }
}

#pragma mark - NSTextView Delegates

- (void)textViewDidChangeSelection:(NSNotification *)notification
{
    if (self.delegate != nil) {
        [self.delegate makeDetailViewFirstResponder];
    }
}

@end
