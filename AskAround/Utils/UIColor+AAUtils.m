//
// Created by Agathe Battestini on 2/22/14.
// Copyright (c) 2014 Holy Moley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+AAUtils.h"


@implementation UIColor (AAUtils)

+ (UIColor*)backgroundGrayColor
{
    return [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
}

+ (UIColor*)darkerTextColor
{
    return [UIColor colorWithRed:70.0/255.0 green:70.0/255.0 blue:70.0/255.0 alpha:1.0];
}

+ (UIColor*)lighterTextColor
{
    return [UIColor colorWithRed:70.0/255.0 green:70.0/255.0 blue:70.0/255.0 alpha:0.7];
}



@end