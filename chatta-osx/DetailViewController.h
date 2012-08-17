//
//  DetailViewController.h
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class CKTextView;
@class CKScrollView;
@class CKContactList;
@class CKContact;
@class CKMessage;

@protocol DetailViewDelegate <NSObject>
@optional
- (void)sendNewMessage:(NSString *)message toContact:(CKContact *)contact;
@end

@interface DetailViewController : NSViewController <NSTextFieldDelegate>

@property (unsafe_unretained) IBOutlet CKTextView *messagesTextView;
@property (weak) IBOutlet NSTextField *messagesInputTextField;
@property (weak) IBOutlet CKScrollView *scrollView;

@property (nonatomic) BOOL enabled;
@property (nonatomic, strong) CKContact *contact;
@property (nonatomic, assign) id <DetailViewDelegate> delegate;

- (void)updateTextViewWithNewMessage:(CKMessage *)message;
- (IBAction)newMessageEntered:(id)sender;

@end
