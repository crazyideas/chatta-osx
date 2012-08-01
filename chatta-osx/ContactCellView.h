//
//  ContactCellView.h
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import <AppKit/AppKit.h>

typedef enum {
    ConnectionStateOnline,
    ConnectionStateOffline,
    ConnectionStateIndeterminate
} ConnectionState;

@interface ContactCellView : NSTableCellView
{
    NSPoint originPoint;
}

@property (nonatomic, retain) IBOutlet NSTextField *displayName;
@property (nonatomic, retain) IBOutlet NSTextField *lastMessage;
@property (nonatomic, retain) IBOutlet NSTextField *lastMessageTimestamp;
@property (nonatomic, retain) IBOutlet NSImageView *connectionStateImageView;

@property (nonatomic) ConnectionState connectionState;
@property (nonatomic) NSUInteger unreadMessageCount;

@end
