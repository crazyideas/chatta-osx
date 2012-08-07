//
//  DetailViewController.h
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CKTextView.h"
#import "CKScrollView.h"
#import "CKContactList.h"
#import "CKContact.h"
#import "CKMessage.h"

@protocol DetailViewDelegate <NSObject>
@optional
- (void)sendNewMessage:(NSString *)message toContact:(CKContact *)contact;
@end

@interface DetailViewController : NSViewController

@property (unsafe_unretained) IBOutlet CKTextView *messagesTextView;
@property (weak) IBOutlet NSTextField *messagesInputTextField;
@property (weak) IBOutlet CKScrollView *scrollView;

@property (nonatomic, strong) CKContact *contact;
@property (nonatomic, assign) id <DetailViewDelegate> delegate;

- (void)updateTextViewWithNewMessage:(CKMessage *)message playSound:(BOOL)sound;

- (IBAction)newMessageEntered:(id)sender;

@end
