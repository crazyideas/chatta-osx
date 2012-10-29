//
//  NSColor+CKAdditions.m
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import "NSColor+CKAdditions.h"

@implementation NSColor (CKAdditions)

+ (NSColor *)greenStatusColor
{
    static NSColor *color = nil;
    if (color == nil) {
        color = [NSColor colorWithCalibratedRed:33/255.0 green:252/255.0 blue:130/255.0 alpha:1.0];
    }
    return color;
}

+ (NSColor *)greenStatusOutlineColor
{
    static NSColor *color = nil;
    if (color == nil) {
        color = [NSColor colorWithCalibratedRed:114/255.0 green:253/255.0 blue:188/255.0 alpha:1.0];
    }
    return color;
}

+ (NSColor *)yellowStatusColor
{
    static NSColor *color = nil;
    if (color == nil) {
        color = [NSColor colorWithCalibratedRed:250/255.0 green:254/255.0 blue:93/255.0 alpha:1.0];
    }
    return color;
}

+ (NSColor *)yellowStatusOutlineColor
{
    static NSColor *color = nil;
    if (color == nil) {
        color = [NSColor colorWithCalibratedRed:232/255.0 green:254/255.0 blue:188/255.0 alpha:1.0];
    }
    return color;
}

+ (NSColor *)blueStatusColor
{
    static NSColor *color = nil;
    if (color == nil) {
        color = [NSColor colorWithCalibratedRed:88/255.0 green:183/255.0 blue:255/255.0 alpha:1.0];
    }
    return color;
}

+ (NSColor *)blueStatusOutlineColor
{
    static NSColor *color = nil;
    if (color == nil) {
        color = [NSColor colorWithCalibratedRed:178/255.0 green:232/255.0 blue:254/255.0 alpha:1.0];
    }
    return color;
}

+ (NSColor *)gridSeparatorColor
{
    static NSColor *color = nil;
    if (color == nil) {
        color = [NSColor colorWithCalibratedRed:193/255.0 green:193/255.0 blue:193/255.0 alpha:1.0];
        //color = [NSColor colorWithDeviceWhite:0.8 alpha:1.0];
    }
    return color;
}

+ (NSColor *)lightBackgroundNoiseColor
{
    static NSImage *image = nil;
    static NSColor *color = nil;
    if (color == nil || image == nil) {
        image = [NSImage imageNamed:@"light_noise.png"];
        color = [NSColor colorWithPatternImage:image];
    }
    return color;
}

+ (NSColor *)mediumBackgroundNoiseColor
{
    static NSImage *image = nil;
    static NSColor *color = nil;
    if (color == nil || image == nil) {
        image = [NSImage imageNamed:@"medium_noise.png"];
        color = [NSColor colorWithPatternImage:image];
    }
    return color;
}

+ (NSColor *)darkBackgroundNoiseColor
{
    static NSImage *image = nil;
    static NSColor *color = nil;
    if (color == nil || image == nil) {
        image = [NSImage imageNamed:@"dark_noise.png"];
        color = [NSColor colorWithPatternImage:image];
    }
    return color;
}

+ (NSColor *)selectionGradientStartColor
{
    static NSColor *color = nil;
    if (color == nil) {
        color = [NSColor colorWithCalibratedRed:202/255.0 green:217/255.0 blue:236/255.0 alpha:1.0];
    }
    return color;
}

+ (NSColor *)selectionGradientEndColor
{
    static NSColor *color = nil;
    if (color == nil) {
        color = [NSColor colorWithCalibratedRed:202/255.0 green:217/255.0 blue:236/255.0 alpha:1.0];
    }
    return color;
}


+ (NSColor *)logoColor
{
    static NSColor *color = nil;
    if (color == nil) {
        color = [NSColor colorWithCalibratedRed:90/255.0 green:67/255.0 blue:210/255.0 alpha:1.0];
    }
    return color;
}

@end
