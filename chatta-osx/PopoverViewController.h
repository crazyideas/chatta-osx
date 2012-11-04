//
//  PopoverViewController.h
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PopoverView.h"

@class CKPhoneNumberFormatter;
@class CKEmailAddressFormatter;
@class CKContact;


@protocol PopoverDelegate <NSObject>
@optional
- (void)addContactWithName:(NSString *)name email:(NSString *)address phone:(NSString *)number;
- (void)updateContact:(CKContact *)contact withName:(NSString *)name email:(NSString *)address
                phone:(NSString *)number;
@end


@interface PopoverViewController : NSViewController <NSPopoverDelegate, NSTextFieldDelegate>

@property (nonatomic, strong) NSPopover *popover;
@property (nonatomic, strong) PopoverView *popoverView;

@property (nonatomic, strong) CKContact *contact;
@property (nonatomic, strong) CKPhoneNumberFormatter *phoneNumberFormatter;
@property (nonatomic, strong) CKEmailAddressFormatter *emailAddressFormatter;

@property (nonatomic, assign) id <PopoverDelegate> delegate;

@property (nonatomic) PopoverType popoverType;

@end
