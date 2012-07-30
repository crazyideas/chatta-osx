//
//  CKTableRowView.h
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum {
    CKTableRowSeparatorStyleNone,
    CKTableRowSeparatorStyleSingleLine,
    CKTableRowSeparatorStyleSingleLineEtched
} CKTableRowSeparatorStyle;

@interface CKTableRowView : NSTableRowView

@property (nonatomic) CKTableRowSeparatorStyle separatorStyle;
@property (strong, nonatomic) NSColor *primaryColor;
@property (strong, nonatomic) NSColor *secondaryColor;

@end
