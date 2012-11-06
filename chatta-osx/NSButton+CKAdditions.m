//
//  NSButton+CKAdditions.m
//  chatta-osx
//
//  Copyright (c) 2012 CRAZY IDEAS. All rights reserved.
//

#import "NSButton+CKAdditions.h"

@implementation NSButton (CKAdditions)

- (NSColor *)titleColor
{
    NSAttributedString *attributedTitle = [self attributedTitle];
    NSRange range = NSMakeRange(0, [attributedTitle length]);
    
    NSDictionary *attributes = [attributedTitle fontAttributesInRange:range];
    NSColor *fontColor = [attributes objectForKey:NSForegroundColorAttributeName];
    
    return fontColor;
}

- (void)setTitleColor:(NSColor *)titleColor
{
    NSAttributedString *attributedTitle = [self attributedTitle];
    NSRange range = NSMakeRange(0, [attributedTitle length]);

    NSMutableAttributedString *title = [[NSMutableAttributedString alloc]
        initWithAttributedString:[self attributedTitle]];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    [shadow setShadowColor:[NSColor whiteColor]];
    [shadow setShadowOffset:NSMakeSize(-0.0, -2.0)];

    [title addAttribute:NSFontAttributeName value:self.font range:range];
    [title addAttribute:NSForegroundColorAttributeName value:titleColor range:range];
    [title addAttribute:NSShadowAttributeName value:shadow range:range];
    [title fixAttributesInRange:range];
    
    [self setAttributedTitle:title];
}

@end
