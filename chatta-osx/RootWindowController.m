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

#import "ConfigureView.h"

@implementation RootWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {        
        NSView *windowContentView = self.window.contentView;
        
        // set window delegate
        self.window.delegate = self;
        
        // create master and detail view controllers
        self.masterViewController      = [[MasterViewController alloc] init];
        self.detailViewController      = [[DetailViewController alloc] init];
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
        
        // adjust the size of the contacts view to be 30% of the window
        CGFloat masterViewWidth = self.splitView.frame.size.width * 0.3;
        CGFloat detailViewWidth = self.splitView.frame.size.width * 0.7;
        [self.splitView setPosition:masterViewWidth ofDividerAtIndex:0];
        
        
        // adjust master views
        CGFloat masterButtonW = detailViewWidth;
        CGFloat masterButtonH = 50;
        CGFloat masterButtonX = (masterViewWidth - masterButtonW) / 2;
        CGFloat masterButtonY = 0;
        self.masterViewController.addContactButton.frame =
            NSMakeRect(masterButtonX, masterButtonY, masterButtonW, masterButtonH);
        
        CGFloat masterScrollW = masterViewWidth;
        CGFloat masterScrollH = self.splitView.frame.size.height - masterButtonH;
        CGFloat masterScrollX = 0;
        CGFloat masterScrollY = 50;
        self.masterViewController.scrollView.frame =
            NSMakeRect(masterScrollX, masterScrollY, masterScrollW, masterScrollH);
        
        // adjust detail views
        CGFloat detailTextFieldW = detailViewWidth - 20;
        CGFloat detailTextFieldH = 30;
        CGFloat detailTextFieldX = (detailViewWidth - detailTextFieldW) / 2;
        CGFloat detailTextFieldY = 9.0 - 3;
        self.detailViewController.detailView.textField.frame =
            NSMakeRect(detailTextFieldX, detailTextFieldY, detailTextFieldW, detailTextFieldH);
        
        CGFloat detailScrollW = detailViewWidth;
        CGFloat detailScrollH = self.splitView.frame.size.height - masterButtonH - 1;
        CGFloat detailScrollX = 0;
        CGFloat detailScrollY = 50 + 1;
        self.detailViewController.detailView.scrollView.frame =
            NSMakeRect(detailScrollX, detailScrollY, detailScrollW, detailScrollH);
        self.detailViewController.detailView.textView.frame =
            NSMakeRect(detailScrollX, detailScrollY, detailScrollW, detailScrollH);
        self.detailViewController.detailView.inputSeparator.frame =
            NSMakeRect(0, 35 + 1, detailScrollW, 15);
        
        //[self.window makeFirstResponder:self.detailViewController.detailView];
        [self.window setBackgroundColor:[NSColor mediumBackgroundNoiseColor]];
        
        // set split view as window content view
        self.window.contentView = self.splitView;
        
        
        CKContact *me = [[CKContact alloc] initWithJabberIdentifier:nil andDisplayName:@"Me" andPhoneNumber:nil];
        self.chattaKit = [[ChattaKit alloc] initWithMe:me];
        self.chattaKit.delegate = self;
        
        //[self showConfigureSheet:self.window];
        [CKPersistence loadContactsFromPersistentStorage];
        [self.masterViewController.tableView reloadData];
        
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
/*
    NSTextField *textField = self.detailViewController.detailView.textField;
    NSText *fieldEditor = [self.window fieldEditor:YES forObject:textField];
    
    [self.window makeFirstResponder:textField];
    
    NSString *newFieldString = (characters) ?
    [NSString stringWithFormat:@"%@%@", fieldEditor.string, characters] : fieldEditor.string;
    [fieldEditor setSelectedRange:NSMakeRange(fieldEditor.string.length, 0)];
    [fieldEditor setString:newFieldString];
    [fieldEditor setNeedsDisplay:YES];
*/
}

- (void)receivedSleepNotification:(NSNotification *)notification
{
    
}

- (void)receivedWakeNotification:(NSNotification *)notification
{
    
}

- (void)receivedAccountPressedNotification:(id)sender
{
    [self showConfigureWindow];
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
    //[self.masterViewController.contactListTableView reloadData];
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
        
        //[self.masterViewController addContactWithName:contact.displayName
         ///                                       email:contact.jabberIdentifier phone:contact.phoneNumber];
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

- (void)keyDown:(NSEvent *)theEvent
{
    [self updateFirstResponder:theEvent.characters];
}

#pragma mark - DetailViewController Delegate

- (void)makeDetailViewFirstResponder
{
    [self updateFirstResponder:nil];
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
    NSLog(@"[+] RootWindowController: loginRequested");
    [self.chattaKit loginToServiceWith:username andPassword:password];
}

- (void)logoutRequested:(id)sender
{
    NSLog(@"[+] RootWindowController: logoutRequested");
    [self.chattaKit logoutOfService];
    [self removeConfigureWindow];
}

- (void)removeWindowRequested:(id)sender
{
    NSLog(@"[+] RootWindowController: removeWindowRequested");
    [self removeConfigureWindow];
}

- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)ctxInfo
{
    [self.configureWindowController.window orderOut:self];
}

@end
