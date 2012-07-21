//
//  DetailViewController.h
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol DetailViewDelegate <NSObject>
@optional
- (void)sendNewMessage:(id)message;
@end

@interface DetailViewController : NSViewController

@property (unsafe_unretained) IBOutlet NSTextView *messagesTextView;
@property (weak) IBOutlet NSTextField *messagesInputTextField;
@property (nonatomic, assign) id <DetailViewDelegate> delegate;

- (IBAction)newMessageEntered:(id)sender;

@end
