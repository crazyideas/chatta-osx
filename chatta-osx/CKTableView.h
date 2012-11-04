//
//  CKTableView.h
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class CKTableView;

@protocol CKTableViewDelegate <NSTableViewDelegate>
@optional
- (void)tableView:(CKTableView *)tableView didSingleClickRow:(NSInteger)row;
- (void)tableView:(CKTableView *)tableView didDoubleClickRow:(NSInteger)row;
- (void)tableView:(CKTableView *)tableView didRequestDeleteRow:(NSInteger)row;
@end

@interface CKTableView : NSTableView

@end
