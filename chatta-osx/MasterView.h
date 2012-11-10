//
//  MasterView.h
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class CKTableView;
@class CKScrollView;

@interface MasterView : NSView

@property (nonatomic, strong) CKScrollView *scrollView;
@property (nonatomic, strong) CKTableView *tableView;
@property (nonatomic, strong) NSTableColumn *tableColumn;
@property (nonatomic, strong) NSBox *lineSeparator;
@property (nonatomic, strong) NSButton *addContactButton;

@end
