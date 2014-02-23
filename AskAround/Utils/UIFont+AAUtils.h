//
// Created by Agathe Battestini on 2/22/14.
// Copyright (c) 2014 Holy Moley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@class UIFont;

@interface UIFont (AAUtils)

+ (UIFont *)mediumFontWithSize:(CGFloat)size;

+ (UIFont *)lightFontWithSize:(CGFloat)size;

+ (UIFont *)italicFontWithSize:(CGFloat)size;

+ (NSDictionary *)mediumStringAttributesWithSize:(CGFloat)size withColor:(UIColor *)color;

+ (NSDictionary *)lightStringAttributesWithSize:(CGFloat)size withColor:(UIColor *)color;

+ (NSDictionary *)paragraphStyleForLineBreakStyle:(NSLineBreakMode)lineBreakMode;
@end