//
//  PopoverViewController.h
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ContactView.h"

@class CKPhoneNumberFormatter;
@class CKEmailAddressFormatter;
@class CKContact;


@protocol ContactViewControllerDelegate <NSObject>
@optional
- (CKContact *)addContactWithName:(NSString *)name email:(NSString *)address phone:(NSString *)number;
- (CKContact *)updateContact:(CKContact *)contact withName:(NSString *)name email:(NSString *)address
                phone:(NSString *)number;
- (void)popoverWillClose:(id)sender;
@end


@interface ContactViewController : NSViewController <NSPopoverDelegate, NSTextFieldDelegate>

@property (nonatomic, strong) NSPopover *popover;
@property (nonatomic, strong) ContactView *contactView;

@property (nonatomic, strong) CKContact *contact;
@property (nonatomic, strong) CKPhoneNumberFormatter *phoneNumberFormatter;
@property (nonatomic, strong) CKEmailAddressFormatter *emailAddressFormatter;

@property (nonatomic, assign) id <ContactViewControllerDelegate> delegate;

@property (nonatomic) ContactViewType contactViewType;

@end
