//
//  DetailView.h
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CKTextView.h"
#import "CKSeparator.h"

@class CKScrollView;
@class CKMessage;
@class CKContact;

@interface DetailView : NSView

@property (nonatomic, strong) CKScrollView *scrollView;
@property (nonatomic, strong) CKTextView *textView;
@property (nonatomic, strong) NSTextField *textField;
@property (nonatomic, strong) CKSeparator *inputSeparator;

- (NSAttributedString *)attributedStringForMessage:(CKMessage *)message;
- (void)appendMessageView:(NSAttributedString *)attributedString;
- (void)replaceMessageView:(NSAttributedString *)attributedString;
- (void)clearMessageView;

@end
