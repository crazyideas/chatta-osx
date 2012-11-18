//
//  MessageView.m
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import "MessageView.h"
#import "CKButton.h"
#import "CKLabel.h"

#import "NSColor+CKAdditions.h"
#import "NSFont+CKAdditions.h"

@implementation MessageView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel       = [[CKLabel alloc] initWithFrame:NSMakeRect           (116, 188,  90, 17)];
        self.segmentedControl = [[NSSegmentedControl alloc] initWithFrame:NSMakeRect( 11, 150, 301, 24)];
        self.serviceLabel     = [[CKLabel alloc] initWithFrame:NSMakeRect           ( 13, 120,  94, 17)];
        self.messageLabel     = [[CKLabel alloc] initWithFrame:NSMakeRect           ( 48,  88,  59, 17)];
        self.serviceTextField = [[NSTextField alloc] initWithFrame:NSMakeRect       (112, 117, 198, 22)];
        self.messageTextField = [[NSTextField alloc] initWithFrame:NSMakeRect       (112,  41, 198, 66)];
        self.sendButton       = [[NSButton alloc] initWithFrame:NSMakeRect          (216,   5, 100, 32)];
        self.noteLabel        = [[CKLabel alloc] initWithFrame:NSMakeRect           ( 10,  11, 221, 17)];
        
        [self.segmentedControl setSegmentCount:2];
        [self.segmentedControl setLabel:@"Google Talk" forSegment:0];
        [self.segmentedControl setLabel:@"Google Voice" forSegment:1];
        [self.segmentedControl setWidth:148 forSegment:0];
        [self.segmentedControl setWidth:148 forSegment:1];
        [self.segmentedControl setSelectedSegment:0];
        [self.segmentedControl setTarget:self];
        [self.segmentedControl setAction:@selector(segmentedControlAction:)];
        
        [self.titleLabel setTextColor:[NSColor darkGrayColor]];
        [self.titleLabel setAttributedStringValue:[NSFont etchedString:@"New Message"
            withFont:[NSFont systemFontOfSize:0]]];
        
        [self.serviceLabel setTextColor:[NSColor darkGrayColor]];
        [self.serviceLabel setAttributedStringValue:[NSFont etchedString:@"Email Address"
            withFont:[NSFont systemFontOfSize:0]]];
        
        [self.messageLabel setTextColor:[NSColor darkGrayColor]];
        [self.messageLabel setAttributedStringValue:[NSFont etchedString:@"Message"
            withFont:[NSFont systemFontOfSize:0]]];
                
        [self.sendButton setTitle:@"Send"];
        [self.sendButton setBezelStyle:NSRoundedBezelStyle];
        [self.sendButton setEnabled:NO];
        
        [self.noteLabel setTextColor:[NSColor darkGrayColor]];
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.segmentedControl];
        [self addSubview:self.serviceLabel];
        [self addSubview:self.messageLabel];
        [self addSubview:self.serviceTextField];
        [self addSubview:self.messageTextField];
        [self addSubview:self.sendButton];
        [self addSubview:self.noteLabel];
        
        // set initial state
        self.messageViewState = MessageViewStateInstantService;
    }
    
    return self;
}

- (void)setMessageViewState:(MessageViewState)messageViewState
{    
    switch (messageViewState) {
        case MessageViewStateInstantService: // Google Talk
        {
            [self.serviceLabel setFrame:NSMakeRect(13, 120, 94,17)];
            [self.serviceLabel setAttributedStringValue:[NSFont etchedString:@"Email Address"
                withFont:[NSFont systemFontOfSize:0]]];
            [self.serviceTextField.cell setPlaceholderString:@"jsmith@gmail.com"];
            [self.noteLabel setHidden:NO];
            
            break;
        }
        case MessageViewStateTextService: // Google Voice
        {
            [self.serviceLabel setFrame:NSMakeRect(9, 120, 98, 17)];
            [self.serviceLabel setAttributedStringValue:[NSFont etchedString:@"Phone Number"
                withFont:[NSFont systemFontOfSize:0]]];
            [self.serviceTextField.cell setPlaceholderString:@"1-800-555-1212"];
            [self.noteLabel setHidden:YES];
            
            break;
        }
        default:
        {
            CKDebug(@"invalid segment selected");
            break;
        }
    }
    
    [self.serviceTextField setStringValue:@""];
    
    [self.messageTextField.cell setPlaceholderString:@"Message..."];
    [self.noteLabel setAttributedStringValue:[NSFont etchedString:@"Message will be sent if contact is online"
        withFont:[NSFont systemFontOfSize:10]]];
    
    _messageViewState = messageViewState;
}

#pragma mark - Overridden Methods

- (void)drawRect:(NSRect)dirtyRect
{
    [[NSColor mediumBackgroundNoiseColor] setFill];
    NSRectFill(dirtyRect);
}

#pragma mark - Actions

- (void)segmentedControlAction:(id)sender
{
    NSInteger selectedSegment = [sender selectedSegment];
    CKDebug(@"[+] MessageView, segmentedControlAction, %li", selectedSegment);
    
    switch (selectedSegment) {
        case 0: // Google Talk
        {
            self.messageViewState = MessageViewStateInstantService;
            break;
        }
        case 1: // Google Voice
        {
            self.messageViewState = MessageViewStateTextService;
            break;
        }
        default:
        {
            CKDebug(@"invalid segment selected");
            break;
        }
    }
}

@end
