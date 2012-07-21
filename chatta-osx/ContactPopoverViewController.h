//
//  ContactPopoverViewController.h
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PhoneNumberFormatter.h"
#import "EmailAddressFormatter.h"

@protocol ContactPopoverDelegate <NSObject>
@optional
- (void)addContactWithName:(NSString *)name email:(NSString *)address phone:(NSString *)number;
- (void)updateContact:(id)contact withName:(NSString *)name email:(NSString *)address phone:(NSString *)number;
- (void)closePopover;
@end

@interface ContactPopoverViewController : NSViewController <NSPopoverDelegate, NSTextFieldDelegate>
{
    BOOL nameValid;
    BOOL emailValid;
    BOOL phoneValid;
}

typedef enum {
    PopoverTypeAddContact,
    PopoverTypeUpdateContact
} PopoverType;

@property (nonatomic) PopoverType popoverType;
@property (nonatomic, strong) id contact;
@property (nonatomic, strong) PhoneNumberFormatter *phoneNumberFormatter;
@property (nonatomic, strong) EmailAddressFormatter *emailAddressFormatter;
@property (nonatomic, assign) id <ContactPopoverDelegate> delegate;

@property (weak) IBOutlet NSTextField *titleTextField;
@property (weak) IBOutlet NSButton *rightButton;
@property (weak) IBOutlet NSButton *leftButton;

@property (weak) IBOutlet NSTextField *nameTextField;
@property (weak) IBOutlet NSTextField *emailTextField;
@property (weak) IBOutlet NSTextField *phoneTextField;

- (IBAction)rightButtonPushed:(id)sender;
- (IBAction)leftButtonPushed:(id)sender;

@end
