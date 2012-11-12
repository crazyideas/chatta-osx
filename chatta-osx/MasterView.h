//
//  MasterView.h
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class CKLabel;
@class CKTableView;
@class CKScrollView;

typedef enum {
    MasterViewStateNormal,
    MasterViewStateNoContacts
} MasterViewState;

@interface MasterView : NSView

@property (nonatomic, strong) CKScrollView *scrollView;
@property (nonatomic, strong) CKTableView *tableView;
@property (nonatomic, strong) NSTableColumn *tableColumn;
@property (nonatomic, strong) NSBox *lineSeparator;
@property (nonatomic, strong) NSButton *addContactButton;
@property (nonatomic, strong) CKLabel *placeholderString;

- (void)changeViewState:(MasterViewState)newMasterViewState;

@end
