//
//  EmailAddressFormatter.h
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EmailAddressFormatter : NSFormatter

+ (BOOL)isValidEmailAddress:(NSString *)emailAddress;

@end
