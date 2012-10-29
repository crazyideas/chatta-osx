//
//  NSColor+CKAdditions.h
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSColor (CKAdditions)

+ (NSColor *)greenStatusColor;
+ (NSColor *)greenStatusOutlineColor;
+ (NSColor *)yellowStatusColor;
+ (NSColor *)yellowStatusOutlineColor;
+ (NSColor *)blueStatusColor;
+ (NSColor *)blueStatusOutlineColor;

+ (NSColor *)gridSeparatorColor;

+ (NSColor *)lightBackgroundNoiseColor;
+ (NSColor *)mediumBackgroundNoiseColor;
+ (NSColor *)darkBackgroundNoiseColor;

+ (NSColor *)selectionGradientStartColor;
+ (NSColor *)selectionGradientEndColor;

+ (NSColor *)logoColor;

@end
