//
//  ContactCellView.h
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import <AppKit/AppKit.h>
#import "CKContact.h"
#import "CKMessage.h"

@interface CKTableViewCellStyleDetailed : NSTableCellView

@property (nonatomic, retain) IBOutlet NSTextField *displayName;
@property (nonatomic, retain) IBOutlet NSTextField *lastMessage;
@property (nonatomic, retain) IBOutlet NSTextField *lastMessageTimestamp;
@property (nonatomic, retain) IBOutlet NSImageView *connectionStateImageView;

@property (nonatomic, strong) CKContact *contact;

@end
