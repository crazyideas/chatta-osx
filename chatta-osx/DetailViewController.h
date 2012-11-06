//
//  DetailViewController.h
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DetailView.h"

@class CKTextView;
@class CKScrollView;
@class CKContactList;
@class CKContact;
@class CKMessage;

@protocol DetailViewControllerDelegate <NSObject>
@optional
- (void)makeDetailViewFirstResponder;
- (void)sendNewMessage:(NSString *)message toContact:(CKContact *)contact;
@end

@interface DetailViewController : NSViewController <NSTextViewDelegate, NSTextFieldDelegate>

@property (nonatomic, strong) DetailView *detailView;

@property (nonatomic, strong) CKContact *contact;
@property (nonatomic, strong) NSMutableDictionary *textStorageCache;
@property (nonatomic) BOOL enabled;

@property (nonatomic, assign) id <DetailViewControllerDelegate> delegate;

- (void)appendNewMessage:(CKMessage *)message forContact:(CKContact *)contact;

@end
