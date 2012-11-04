//
//  PopoverView.h
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CKLabel.h"

@interface PopoverView : NSView

typedef enum {
    PopoverTypeAddContact,
    PopoverTypeUpdateContact
} PopoverType;

@property (nonatomic, strong) CKLabel *titleLabel;
@property (nonatomic, strong) CKLabel *nameLabel;
@property (nonatomic, strong) CKLabel *emailLabel;
@property (nonatomic, strong) CKLabel *phoneLabel;

@property (nonatomic, strong) NSTextField *nameTextField;
@property (nonatomic, strong) NSTextField *emailTextField;
@property (nonatomic, strong) NSTextField *phoneTextField;

@property (nonatomic, strong) NSButton *leftButton;
@property (nonatomic, strong) NSButton *rightButton;

@property (nonatomic) PopoverType popoverType;

@end
