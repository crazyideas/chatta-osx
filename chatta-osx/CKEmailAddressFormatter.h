//
//  EmailAddressFormatter.h
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CKEmailAddressFormatter : NSFormatter

+ (BOOL)isValidEmailAddress:(NSString *)emailAddress;

@end
