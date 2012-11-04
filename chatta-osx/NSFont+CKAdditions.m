//
//  NSFont+CKAdditions.m
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import "NSFont+CKAdditions.h"

/**
 * Available Helvetica Neue Fonts:
 *
 *    1. HelveticaNeue
 *    2. HelveticaNeue-Bold
 *    3. HelveticaNeue-BoldItalic
 *    4. HelveticaNeue-CondensedBlack
 *    5. HelveticaNeue-CondensedBold
 *    6. HelveticaNeue-Italic
 *    7. HelveticaNeue-Light
 *    8. HelveticaNeue-LightItalic
 *    9. HelveticaNeue-Medium
 *   10. HelveticaNeue-UltraLight
 *   11. HelveticaNeue-UltraLightItalic
 */

@implementation NSFont (CKAdditions)

+ (NSFont *)applicationLightSmall
{
    static NSFont *font = nil;
    if (font == nil) {
        font = [NSFont fontWithName:@"HelveticaNeue-Light" size:12.0];
    }
    return font;
}

+ (NSFont *)applicationLightMedium
{
    static NSFont *font = nil;
    if (font == nil) {
        font = [NSFont fontWithName:@"HelveticaNeue-Light" size:14.0];
    }
    return font;
    
}

+ (NSFont *)applicationLightLarge
{
    static NSFont *font = nil;
    if (font == nil) {
        font = [NSFont fontWithName:@"HelveticaNeue-Light" size:18.0];
    }
    return font;
    
}



+ (NSFont *)applicationRegularSmall
{
    static NSFont *font = nil;
    if (font == nil) {
        font = [NSFont fontWithName:@"HelveticaNeue-Medium"  size:12.0];
    }
    return font;
}

+ (NSFont *)applicationRegularMedium
{
    static NSFont *font = nil;
    if (font == nil) {
        font = [NSFont fontWithName:@"HelveticaNeue-Medium"  size:14.0];
    }
    return font;
}



+ (NSFont *)applicationRegularLarge
{
    static NSFont *font = nil;
    if (font == nil) {
        font = [NSFont fontWithName:@"HelveticaNeue-Medium"  size:18.0];
    }
    return font;
}

+ (NSFont *)applicationBoldSmall
{
    static NSFont *font = nil;
    if (font == nil) {
        font = [NSFont fontWithName:@"HelveticaNeue-Bold"  size:12.0];
    }
    return font;
}

+ (NSFont *)applicationBoldMedium
{
    static NSFont *font = nil;
    if (font == nil) {
        font = [NSFont fontWithName:@"HelveticaNeue-Bold"  size:14.0];
    }
    return font;
}

+ (NSFont *)applicationBoldLarge
{
    static NSFont *font = nil;
    if (font == nil) {
        font = [NSFont fontWithName:@"HelveticaNeue-Bold"  size:18.0];
    }
    return font;
}



+ (NSFont *)applicationLogo
{
    static NSFont *font = nil;
    if (font == nil) {
        font = [NSFont fontWithName:@"Cookie-Regular" size:60];
    }
    return font;
}



+ (NSAttributedString *)etchedString:(NSString *)string withFont:(NSFont *)font
{
    // attributed string with white etched shadow
    NSShadow *shadow = [[NSShadow alloc] init];
    [shadow setShadowColor:[NSColor whiteColor]];
    [shadow setShadowOffset:NSMakeSize(-0.0, -2.0)];

    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       font,   NSFontAttributeName,
                                       shadow, NSShadowAttributeName,
                                       nil];
    
    return [[NSAttributedString alloc] initWithString:string attributes:attributes];
}

@end
