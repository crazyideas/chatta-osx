//
//  MessageViewController.m
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import "MessageViewController.h"

@implementation MessageViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.popover     = [[NSPopover alloc] init];
        self.messageView = [[MessageView alloc] initWithFrame:NSMakeRect(0, 0, 320, 185)];
        
        [self.popover setContentViewController:self];
        [self.popover setAnimates:YES];
        [self.popover setBehavior:NSPopoverBehaviorTransient];
        [self.popover setDelegate:self];
        
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
    if (self.delegate != nil) {
        [self.delegate popoverWillClose:self];
    }
}

@end
