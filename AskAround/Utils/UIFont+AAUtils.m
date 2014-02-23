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





@end