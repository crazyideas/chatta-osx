//
//  ContactPopoverViewController.h
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ChattaKit;
@class CKContact;
@class CKPhoneNumberFormatter;
@class CKEmailAddressFormatter;


@protocol ContactPopoverDelegate <NSObject>
@optional
- (void)addContactWithName:(NSString *)name email:(NSString *)address phone:(NSString *)number;
- (void)updateContact:(CKContact *)contact withName:(NSString *)name email:(NSString *)address
                phone:(NSString *)number;
- (void)closePopover;
@end

@interface ContactPopoverViewController : NSViewController <NSPopoverDelegate, NSTextFieldDelegate,
                                                            NSTokenFieldDelegate>

typedef enum {
    PopoverTypeAddContact,
    PopoverTypeUpdateContact
} PopoverType;

@property (nonatomic) PopoverType popoverType;
@property (nonatomic, strong) ChattaKit *chattaKit;
@property (nonatomic, strong) CKContact *contact;
@property (nonatomic, strong) CKPhoneNumberFormatter *phoneNumberFormatter;
@property (nonatomic, strong) CKEmailAddressFormatter *emailAddressFormatter;
@property (nonatomic, assign) id <ContactPopoverDelegate> delegate;

@property (weak) IBOutlet NSTextField *titleTextField;
@property (weak) IBOutlet NSButton *rightButton;
@property (weak) IBOutlet NSButton *leftButton;

@property (weak) IBOutlet NSTextField *nameTextField;
@property (weak) IBOutlet NSTextField *phoneTextField;
@property (weak) IBOutlet NSTokenField *emailTokenField;

- (IBAction)rightButtonPushed:(id)sender;
- (IBAction)leftButtonPushed:(id)sender;

@end
