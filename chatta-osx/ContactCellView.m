//
//  ContactCellView.m
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import "ContactCellView.h"
#import "CKViewAnimationUtility.h"
#import <QuartzCore/QuartzCore.h>

@implementation ContactCellView

@synthesize displayName              = _displayName;
@synthesize lastMessage              = _lastMessage;
@synthesize lastMessageTimestamp     = _lastMessageTimestamp;
@synthesize connectionStateImageView = _statusImageView;
@synthesize connectionState          = _connectionState;
@synthesize unreadMessageCount       = _unreadMessageCount;


- (void)setUnreadMessageCount:(NSUInteger)unreadMessageCount
{
    if (unreadMessageCount == 0) {
        [CKViewAnimationUtility stopOpacityAnimationOnLayer:self.connectionStateImageView];
    }
    
    if (unreadMessageCount > 0) {
        [CKViewAnimationUtility startOpacityAnimationOnLayer:self.connectionStateImageView];
    }

    _unreadMessageCount = unreadMessageCount;
}

- (NSDictionary *)connectionStateLookup
{
    static NSMutableDictionary *_lookupDict = nil;
    
    if(_lookupDict == nil) { 
        _lookupDict = [[NSMutableDictionary alloc] initWithCapacity:3];
        [_lookupDict setObject:[NSValue valueWithPoint:NSMakePoint(originPoint.x, originPoint.y + 0)]
                        forKey:[NSNumber numberWithInt:ConnectionStateIndeterminate]];
        
        [_lookupDict setObject:[NSValue valueWithPoint:NSMakePoint(originPoint.x, originPoint.y + 46)] 
                        forKey:[NSNumber numberWithInt:ConnectionStateOffline]];
        
        [_lookupDict setObject:[NSValue valueWithPoint:NSMakePoint(originPoint.x, originPoint.y + 92)]
                        forKey:[NSNumber numberWithInt:ConnectionStateOnline]];
    }
    return [_lookupDict copy];
}

- (void)awakeFromNib
{
    originPoint = NSMakePoint(self.connectionStateImageView.frame.origin.x, 
                              self.connectionStateImageView.frame.origin.y);
}

- (void)setConnectionState:(ConnectionState)toState
{    
    NSNumber *stateNumber = [NSNumber numberWithInt:toState];
    
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        context.duration = 0.22;
        NSPoint newPosition = [[[self connectionStateLookup] objectForKey:stateNumber] pointValue];
        [self.connectionStateImageView.animator setFrameOrigin:newPosition];
    } completionHandler:nil];
    
    _connectionState = toState;
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
