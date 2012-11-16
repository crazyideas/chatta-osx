//
//  MessageViewController.h
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MessageView.h"

@protocol MessageViewControllerDelegate <NSObject>
@optional
- (void)popoverWillClose:(id)sender;
@end

@interface MessageViewController : NSViewController <NSPopoverDelegate>

@property (nonatomic, strong) NSPopover *popover;
@property (nonatomic, strong) MessageView *messageView;

@property (nonatomic, assign) id <MessageViewControllerDelegate> delegate;

@end