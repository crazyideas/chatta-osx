//
//  NSFont+CKAdditions.h
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSFont (CKAdditions)

+ (NSFont *)applicationLightSmall;
+ (NSFont *)applicationLightMedium;
+ (NSFont *)applicationLightLarge;

+ (NSFont *)applicationRegularSmall;
+ (NSFont *)applicationRegularMedium;
+ (NSFont *)applicationRegularLarge;

+ (NSFont *)applicationBoldSmall;
+ (NSFont *)applicationBoldMedium;
+ (NSFont *)applicationBoldLarge;

+ (NSFont *)applicationLogo;

+ (NSAttributedString *)etchedString:(NSString *)string withFont:(NSFont *)font;

@end
