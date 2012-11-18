//
//  MessageView.h
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class CKButton;
@class CKLabel;

typedef enum {
    MessageViewStateTextService,
    MessageViewStateInstantService
} MessageViewState;

@interface MessageView : NSView

@property (nonatomic, strong) CKLabel *titleLabel;
@property (nonatomic, strong) NSSegmentedControl *segmentedControl;
@property (nonatomic, strong) CKLabel *serviceLabel;
@property (nonatomic, strong) CKLabel *messageLabel;
@property (nonatomic, strong) NSTextField *serviceTextField;
@property (nonatomic, strong) NSTextField *messageTextField;
@property (nonatomic, strong) NSButton *sendButton;
@property (nonatomic ,strong) CKLabel *noteLabel;

@property (nonatomic) MessageViewState messageViewState;

@end
