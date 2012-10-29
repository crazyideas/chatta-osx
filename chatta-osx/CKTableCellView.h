//
//  CKTableCellView.h
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CKLabel.h"
#import "CKTextView.h"

@interface CKTableCellView : NSTableCellView

@property (nonatomic, strong) CKLabel *nameLabel;
@property (nonatomic, strong) CKLabel *messageLabel;
@property (nonatomic, strong) CKLabel *timestampLabel;

@property (nonatomic) ContactState contactState;

@end
