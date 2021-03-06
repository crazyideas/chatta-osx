//
//  DetailView.m
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import "DetailView.h"

#import "NSFont+CKAdditions.h"
#import "NSColor+CKAdditions.h"

#import "CKMessage.h"
#import "CKContact.h"

#import "CKTextView.h"
#import "CKScrollView.h"
#import "CKSeparator.h"

@implementation DetailView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollView     = [[CKScrollView alloc] initWithFrame:NSZeroRect];
        self.textView       = [[CKTextView alloc] initWithFrame:NSZeroRect];
        self.textField      = [[NSTextField alloc] initWithFrame:NSZeroRect];
        self.inputSeparator = [[CKSeparator alloc] initWithFrame:NSZeroRect];
                
        [self.textView setAutoresizesSubviews:YES];
        [self.textView setAutoresizingMask: NSViewWidthSizable | NSViewHeightSizable ];
        [self.textView setBackgroundColor:[NSColor lightBackgroundNoiseColor]];
        
        [self.scrollView setDocumentView:self.textView];
        [self.scrollView setHasVerticalScroller:YES];
        [self.scrollView setAutoresizesSubviews:YES];
        [self.scrollView setAutoresizingMask:NSViewHeightSizable | NSViewWidthSizable |
            NSViewMinXMargin | NSViewMaxXMargin | NSViewMaxYMargin ];
        
        [self.textField setAutoresizingMask:NSViewWidthSizable | NSViewMaxYMargin];
        [self.textField setBezeled:NO];
        [self.textField setDrawsBackground:NO];
        
        [self.textField.cell setPlaceholderString:@"Sign in to chat..."];
        [self.textField.cell setFocusRingType:NSFocusRingTypeNone];
        [self.textField.cell setFont:[NSFont applicationLightLarge]];
        [self.textField.cell setLineBreakMode:NSLineBreakByTruncatingTail];
        
        [self.inputSeparator setHasNotch:YES];
        [self.inputSeparator setBackgroundColor:[NSColor lightBackgroundNoiseColor]];
        [self.inputSeparator setAutoresizingMask:NSViewWidthSizable | NSViewMaxYMargin];
        [self.inputSeparator setWantsLayer:YES];
        
        // adjust text field
        CGFloat detailTextFieldW = frame.size.width - 20;
        CGFloat detailTextFieldH = 30;
        CGFloat detailTextFieldX = (frame.size.width - detailTextFieldW) / 2;
        CGFloat detailTextFieldY = 9.0 - 3;
        self.textField.frame =
        NSMakeRect(detailTextFieldX, detailTextFieldY, detailTextFieldW, detailTextFieldH);
        
        // adjust scrollview, textview, and inputseparator
        CGFloat detailScrollW = frame.size.width;
        CGFloat detailScrollH = frame.size.height - 50 - 1;
        CGFloat detailScrollX = 0;
        CGFloat detailScrollY = 50 + 1;
        self.scrollView.frame =
            NSMakeRect(detailScrollX, detailScrollY, detailScrollW, detailScrollH);
        self.textView.frame =
            NSMakeRect(detailScrollX, detailScrollY, detailScrollW, detailScrollH);
        self.inputSeparator.frame =
            NSMakeRect(0, 35 + 1, detailScrollW, 15);

        [self addSubview:self.scrollView];
        [self addSubview:self.inputSeparator];
        [self addSubview:self.textField];
    }
    
    return self;
}

- (NSAttributedString *)attributedStringForMessage:(CKMessage *)message
{
    NSMutableAttributedString *attrString =
    [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:
                                                       @"(%@) %@: %@\n", message.timestampString, message.contact.displayName, message.text]];
    
    NSRange boldRange = [attrString.string rangeOfString:message.contact.displayName];
    NSRange greyRange = [attrString.string rangeOfString:
                         [NSString stringWithFormat:@"(%@)", message.timestampString]];
    
    [attrString beginEditing];
    [attrString addAttribute:NSFontAttributeName
                       value:[NSFont applicationLightMedium]
                       range:NSMakeRange(0, [attrString length])];
    [attrString addAttribute:NSFontAttributeName
                       value:[NSFont applicationBoldMedium]
                       range:boldRange];
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:[NSColor disabledControlTextColor]
                       range:greyRange];
    [attrString endEditing];
    
    return attrString;
}

- (void)appendMessageView:(NSAttributedString *)attributedString
{
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [self.textView.textStorage appendAttributedString:attributedString];
        
        // scroll to bottom, for some reason [self.scrollView scrollToBottom] doesn't like
        // huge lines, so for those cases use, [self.messagesTextView scrollRangeToVisible:range]
        if (attributedString.length > 200) {
            NSRange range = NSMakeRange(self.textView.attributedString.length, 0);
            [self.textView scrollRangeToVisible:range];
        } else {
            NSRange range = NSMakeRange(self.textView.attributedString.length, 0);
            [self.textView scrollRangeToVisible:range];
        }
        
        [self.textView setEnabledTextCheckingTypes:NSTextCheckingTypeLink];
        [self.textView checkTextInDocument:self];
        [self.textView setNeedsDisplay:YES];
    });
}

- (void)replaceMessageView:(NSAttributedString *)attributedString
{
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [self.textView.textStorage setAttributedString:attributedString];
        
        // scroll to bottom, for some reason [self.scrollView scrollToBottom] doesn't like
        // huge lines, so for those cases use, [self.messagesTextView scrollRangeToVisible:range]
        if (attributedString.length > 200) {
            NSRange range = NSMakeRange(self.textView.attributedString.length, 0);
            [self.textView scrollRangeToVisible:range];
        } else {
            [self.scrollView scrollToBottom];
        }
        [self.textView setNeedsDisplay:YES];
    });
}

- (void)clearMessageView
{
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        NSAttributedString *blankAttributedString = [[NSAttributedString alloc] initWithString:@""];
        self.textField.stringValue = @"";
        [self.textView.textStorage setAttributedString:blankAttributedString];
        [self.textView setNeedsDisplay:YES];
        [self.scrollView scrollToBottom];
    });
}

#pragma mark - Overridden Methods

- (BOOL)acceptsFirstResponder
{
    return YES;
}

- (void)keyDown:(NSEvent *)event
{
    CKDebug(@"[+] DetailView, keyDown, %@", event.characters);
    [super keyDown:event];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    [[NSColor lightBackgroundNoiseColor] setFill];
    NSRectFill(dirtyRect);
}

@end
