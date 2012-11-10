//
//  RootWindowController.m
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import "RootWindowController.h"
#import "NSColor+CKAdditions.h"

#import "CKPhoneNumberFormatter.h"
#import "CKPersistence.h"
#import "CKContactList.h"
#import "CKContact.h"
#import "CKMessage.h"
#import "CKTableView.h"
#import "CKScrollView.h"
#import "MasterView.h"

#import "ConfigureView.h"

@implementation RootWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {        
        NSView *windowContentView = self.window.contentView;
        
        // master view will start out to be 30% of the window
        CGFloat masterViewWidth = windowContentView.bounds.size.width * 0.3;
        CGFloat detailViewWidth = windowContentView.bounds.size.width * 0.7;
        
        NSRect masterViewRect = NSMakeRect(0, 0, masterViewWidth, windowContentView.bounds.size.height);
        NSRect detailViewRect = NSMakeRect(0, 0, detailViewWidth, windowContentView.bounds.size.height);
        
        // create master and detail view controllers
        self.masterViewController      = [[MasterViewController alloc] initWithFrame:masterViewRect];
        self.detailViewController      = [[DetailViewController alloc] initWithFrame:detailViewRect];
        self.configureWindowController = [[ConfigureWindowController alloc] init];
        
        self.detailViewController.delegate = self;
        self.configureWindowController.delegate = self;
        
        // create and init splitview
        self.splitView = [[NSSplitView alloc] initWithFrame:windowContentView.bounds];
        [self.splitView addSubview:self.masterViewController.view];
        [self.splitView addSubview:self.detailViewController.view];
        [self.splitView setDividerStyle:NSSplitViewDividerStyleThin];
        [self.splitView setVertical:YES];
        [self.splitView setDelegate:self];
        [self.splitView adjustSubviews];
        [self.splitView setPosition:masterViewWidth ofDividerAtIndex:0];
        
        // setup window
        [self.window setDelegate:self];
        [self.window setBackgroundColor:[NSColor mediumBackgroundNoiseColor]];
        [self.window setContentView:self.splitView];
        
        // setup model
        CKContact *me = [[CKContact alloc] initWithJabberIdentifier:nil andDisplayName:@"Me" andPhoneNumber:nil];
        self.chattaKit = [[ChattaKit alloc] initWithMe:me];
        self.chattaKit.delegate = self;
        
        [CKPersistence loadContactsFromPersistentStorage];
        [self.masterViewController.masterView.tableView reloadData];
        
        self.masterViewController.chattaKit = self.chattaKit;
        self.masterViewController.detailViewController = self.detailViewController;
        self.masterViewController.delegate = self;
        
        self.configureWindowController.chattaState = ChattaStateDisconnected;
        [self showConfigureWindow];
    }
    
    return self;
}

- (void)updateFirstResponder:(NSString *)characters
{
    NSTextField *textField = self.detailViewController.detailView.textField;
    NSText *fieldEditor = [self.window fieldEditor:YES forObject:textField];
    
    [self.window makeFirstResponder:textField];
    
    NSString *newFieldString = (characters) ?
        [NSString stringWithFormat:@"%@%@", fieldEditor.string, characters] : fieldEditor.string;
    [fieldEditor setSelectedRange:NSMakeRange(fieldEditor.string.length, 0)];
    [fieldEditor setString:newFieldString];
    [fieldEditor setNeedsDisplay:YES];
}

- (void)receivedSleepNotification:(NSNotification *)notification
{
    CKDebug(@"[+] RootWindowController: receivedSleepNotification");
    [self logoutRequested:self];
}

- (void)receivedWakeNotification:(NSNotification *)notification
{
    CKDebug(@"[+] RootWindowController: receivedWakeNotification");
    [self showConfigureWindow];
}

- (void)receivedAccountPressedNotification:(id)sender
{
    [self showConfigureWindow];
}

- (void)receivedUpdateContactNotification:(id)sender
{
    [self.masterViewController updateSelectedContact:sender];
}

- (void)receivedRemoveContactNotification:(id)sender
{
    [self.masterViewController removeSelectedContact:sender];
}

#pragma mark - ChattaKit Delegates

- (void)connectionStateNotification:(ChattaState)state
{
    __block RootWindowController *block_self = self;

    switch (state) {
        case ChattaStateConnecting:
        {
            CKDebug(@"[+] received ChattaStateConnecting notification");
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [block_self.configureWindowController.configureView
                    changeViewState:ConfigureViewStateProgress];
            });
            break;
        }
        case ChattaStateConnected:
        {
            CKDebug(@"[+] received ChattaStateConnected notification");
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [block_self.configureWindowController.configureView
                    changeViewState:ConfigureViewStateNormalConnected];
                [block_self removeConfigureWindow];
                
                if ([CKPersistence firstRunOfChatta] == YES) {
                    CKDebug(@"[+] first run of chatta, importing contacts");
                    [block_self deleteAndReimportContacts:self];
                }
            });
            break;
        }
        case ChattaStateErrorDisconnected:
        {
            CKDebug(@"[+] received ChattaStateErrorDisconnected notification");
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [block_self.configureWindowController.configureView
                    changeViewState:ConfigureViewStateError];
            });
            break;
        }
        case ChattaStateDisconnected:
        {
            CKDebug(@"[+] received ChattaStateDisconnected notification");
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [block_self.configureWindowController.configureView
                    changeViewState:ConfigureViewStateNormalDisconnected];
                [block_self showConfigureWindow];
            });
            
            break;
        }
        default:
        {
            CKDebug(@"connectionStateNotification: invalid state");
            break;
        }
    }
    
    self.configureWindowController.chattaState = state;
}

- (void)deleteAndReimportContacts:(id)sender
{
    [[CKContactList sharedInstance] removeAllContacts];
    [self.masterViewController.masterView.tableView reloadData];
    [self.chattaKit requestMostContacted];
}

- (void)mostContacted:(NSArray *)contacts
{
    if (contacts == nil || contacts.count <= 0) {
        return;
    }
    
    for (CKContact *contact in contacts) {
        // cleanup phone number
        if (contact.phoneNumber != nil) {
            contact.phoneNumber = [CKPhoneNumberFormatter phoneNumberInServiceFormat:contact.phoneNumber];
        }
        
        // set display name incase we don't have one
        if (contact.displayName == nil) {
            contact.displayName =
            (contact.phoneNumber == nil) ? contact.jabberIdentifier : contact.phoneNumber;
        }
        
        [self.masterViewController addContactWithName:contact.displayName
            email:contact.jabberIdentifier phone:contact.phoneNumber];
    }
}

#pragma mark - MasterViewController Delegates

- (void)selectedContactDidChange:(CKContact *)contact
{
    if (self.delegate != nil) {
        [self.delegate selectedContactDidChange:contact];
    }
}

#pragma mark - Sheet Methods

- (void)showConfigureWindow
{
    [NSApp beginSheet:self.configureWindowController.window
       modalForWindow:self.window
        modalDelegate:self
       didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:)
          contextInfo:nil];
}

- (void)removeConfigureWindow
{
    [NSApp endSheet:self.configureWindowController.window];
}

#pragma mark - Event Handling

- (void)keyDown:(NSEvent *)event
{
    CKDebug(@"[+] RootWindowController, keyDown, %@", event.characters);
    if ([event.characters characterAtIndex:0] != NSDeleteFunctionKey) {
        [self updateFirstResponder:event.characters];        
    }
    
    [super keyUp:event];
}

- (void)sendNewMessage:(NSString *)message toContact:(CKContact *)contact
{
    CKDebug(@"[+] sending message: %@, to contact: %@", message, contact);
    if (self.chattaKit != nil) {
        [self.chattaKit sendMessage:message toContact:contact];
    }
}

#pragma mark - NSSplitView Delegate

- (CGFloat)splitView:(NSSplitView *)splitView constrainMinCoordinate:(CGFloat)proposedMinPosition
         ofSubviewAt:(NSInteger)dividerIndex
{
    return 200;
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)proposedMaximumPosition
         ofSubviewAt:(NSInteger)dividerIndex
{
    return 375;
}

#pragma mark - NSWindow Delegate

- (NSSize)windowWillResize:(NSWindow *)sender toSize:(NSSize)frameSize
{
    // minimum frame size 600 x 400 (width x height)
    
    if (frameSize.width < 600.0 && frameSize.height < 400.0) {
        return NSMakeSize(600.0, 400.0);
    }
    
    if (frameSize.width < 600.0) {
        return NSMakeSize(600.0, frameSize.height);
    }
    
    if (frameSize.height < 400.0) {
        return NSMakeSize(frameSize.width, 400.0);
    }
    
    return frameSize;
}

- (void)windowDidBecomeMain:(NSNotification *)notification
{
    if (self.masterViewController != nil) {
        self.masterViewController.isVisible = YES;
    }
    NSDockTile *dockTile = [[NSApplication sharedApplication] dockTile];
    dockTile.badgeLabel = @"";
}

- (void)windowDidResignMain:(NSNotification *)notification
{
    if (self.masterViewController != nil) {
        self.masterViewController.isVisible = NO;
    }
}

#pragma mark - ConfigureWindow Delegates

- (void)loginRequested:(id)sender withUsername:(NSString *)username password:(NSString *)password
{
    CKDebug(@"[+] RootWindowController: loginRequested");
    [self.chattaKit loginToServiceWith:username andPassword:password];
}

- (void)logoutRequested:(id)sender
{
    CKDebug(@"[+] RootWindowController: logoutRequested");
    [self.chattaKit logoutOfService];
    [self removeConfigureWindow];
}

- (void)removeWindowRequested:(id)sender
{
    CKDebug(@"[+] RootWindowController: removeWindowRequested");
    [self removeConfigureWindow];
}

- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)ctxInfo
{
    [self.configureWindowController.window orderOut:self];
}

@end
