//
// Created by Agathe Battestini on 2/22/14.
// Copyright (c) 2014 Holy Moley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIFont+AAUtils.h"


@implementation UIFont (AAUtils)

/**
* HelveticaNeue-Bold,
HelveticaNeue-CondensedBlack,
HelveticaNeue-Medium,
HelveticaNeue,
HelveticaNeue-Light,
HelveticaNeue-CondensedBold,
HelveticaNeue-LightItalic,
HelveticaNeue-UltraLightItalic,
HelveticaNeue-UltraLight,
HelveticaNeue-BoldItalic,
HelveticaNeue-Italic

*/
+ (UIFont*)mediumFontWithSize:(CGFloat )size
{
    return [UIFont fontWithName:@"HelveticaNeue-Medium" size:size];
}

+(UIFont*)lightFontWithSize:(CGFloat )size
{
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:size];
}
+ (UIFont*)italicFontWithSize:(CGFloat )size
{
    return [UIFont fontWithName:@"Palatino-Italic" size:size];
}


+ (NSDictionary *)mediumStringAttributesWithSize:(CGFloat)size withColor:(UIColor*)color
{
    return @{ NSFontAttributeName : [UIFont mediumFontWithSize:size],
//            NSUnderlineStyleAttributeName : @1 ,
            NSForegroundColorAttributeName : color
    };
}

+ (NSDictionary *)lightStringAttributesWithSize:(CGFloat)size withColor:(UIColor*)color
{
    return @{ NSFontAttributeName : [UIFont mediumFontWithSize:size],
//            NSUnderlineStyleAttributeName : @1 ,
            NSForegroundColorAttributeName : color
    };
}

+ (NSDictionary *)paragraphStyleForLineBreakStyle:(NSLineBreakMode)lineBreakMode
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = lineBreakMode;
    return paragraphStyle;
}

@end