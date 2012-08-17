//
//  ContactCellView.m
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "CKTableViewCellStyleDetailed.h"
#import "CKViewAnimationUtility.h"

#import "CKContact.h"
#import "CKMessage.h"


@implementation CKTableViewCellStyleDetailed

- (void)updateUnreadMessageCount:(NSUInteger)unreadMessageCount
{
    if (unreadMessageCount == 0) {
        self.lastMessage.font = [NSFont fontWithName:@"Helvetica" size:11];
        self.lastMessageTimestamp.font = [NSFont fontWithName:@"Helvetica" size:12];
        [CKViewAnimationUtility stopOpacityAnimationOnLayer:self.connectionStateImageView];
        [CKViewAnimationUtility stopPulseAnimationOnLayer:self.connectionStateImageView];

    }
    
    if (unreadMessageCount > 0) {
        self.lastMessage.font = [NSFont fontWithName:@"Helvetica-Bold" size:11];
        self.lastMessageTimestamp.font = [NSFont fontWithName:@"Helvetica-Bold" size:12];
        [CKViewAnimationUtility startOpacityAnimationOnLayer:self.connectionStateImageView];
        [CKViewAnimationUtility startPulseAnimationOnLayer:self.connectionStateImageView];
    }
}

- (void)transitionToConnectionState:(ContactState)state withAnimation:(BOOL)animated
{
    NSNumber *stateNumber = [NSNumber numberWithInt:state];
    
    if (animated) {
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            __block CKTableViewCellStyleDetailed *block_self = self;
            context.duration = 0.22;
            NSPoint newPosition =
                [[[self connectionStateLookup] objectForKey:stateNumber] pointValue];
            [block_self.connectionStateImageView.animator setFrameOrigin:newPosition];
        } completionHandler:nil];
    }
    // not animated
    else {
        NSPoint newPosition = [[[self connectionStateLookup] objectForKey:stateNumber] pointValue];
        CGSize newSize = self.connectionStateImageView.frame.size;
        self.connectionStateImageView.frame =
            NSMakeRect(newPosition.x, newPosition.y, newSize.width, newSize.height);
    }
}

- (NSDictionary *)connectionStateLookup
{
    static NSMutableDictionary *_lookupDict = nil;
    NSPoint originPoint = NSMakePoint(self.connectionStateImageView.frame.origin.x,
                                      self.connectionStateImageView.frame.origin.y);
    
    if(_lookupDict == nil) {
        _lookupDict = [[NSMutableDictionary alloc] initWithCapacity:3];
        [_lookupDict setObject:[NSValue valueWithPoint:NSMakePoint(originPoint.x, originPoint.y + 0)]
                        forKey:[NSNumber numberWithInt:ContactStateIndeterminate]];
        
        [_lookupDict setObject:[NSValue valueWithPoint:NSMakePoint(originPoint.x, originPoint.y + 42)]
                        forKey:[NSNumber numberWithInt:ContactStateOffline]];
        
        [_lookupDict setObject:[NSValue valueWithPoint:NSMakePoint(originPoint.x, originPoint.y + 99)]
                        forKey:[NSNumber numberWithInt:ContactStateOnline]];
    }
    return [_lookupDict copy];
}

- (void)setContact:(CKContact *)contact
{
    self.displayName.stringValue = contact.displayName;
    
    CKMessage *lastMessage = contact.messages.lastObject;
    self.lastMessage.stringValue = (lastMessage == nil) ? @"" : lastMessage.text;
    
    self.lastMessageTimestamp.stringValue =
        (lastMessage == nil) ? @"" : lastMessage.timestampString;
    
    [self transitionToConnectionState:contact.connectionState withAnimation:NO];
    [self updateUnreadMessageCount:contact.unreadCount];
    
    _contact = contact;
}

- (void)setBackgroundStyle:(NSBackgroundStyle)backgroundStyle
{
    [super setBackgroundStyle:backgroundStyle];
    
    switch (backgroundStyle) {
        case NSBackgroundStyleLight:
        {
            self.displayName.textColor          = [NSColor blackColor];
            self.lastMessage.textColor          = [NSColor grayColor];
            self.lastMessageTimestamp.textColor = [NSColor alternateSelectedControlColor];
            break;
        }
        case NSBackgroundStyleDark:
        {
            self.displayName.textColor          = [NSColor windowBackgroundColor];
            self.lastMessage.textColor          = [NSColor windowBackgroundColor];
            self.lastMessageTimestamp.textColor = [NSColor windowBackgroundColor];
            break;
        }
        default:
        {
            break;
        }
    }
}

@end
