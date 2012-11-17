//
//  MessageView.h
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class CKButton;
@class CKLabel;

@interface MessageView : NSView

@property (nonatomic, strong) CKButton *leftButton;
@property (nonatomic, strong) CKButton *rightButton;

@property (nonatomic, strong) CKLabel *serviceLabel;
@property (nonatomic, strong) CKLabel *messageLabel;

@property (nonatomic, strong) NSTextField *serviceTextField;
@property (nonatomic, strong) NSTextField *messageTextField;

@property (nonatomic, strong) NSButton *sendButton;
@property (nonatomic ,strong) CKLabel *noteLabel;

@end