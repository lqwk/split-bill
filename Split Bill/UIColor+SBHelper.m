//
//  UIColor+SBHelper.m
//  Split Bill
//
//  Created by Qingwei Lan on 1/30/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//

#import "UIColor+SBHelper.h"

@implementation UIColor (SBHelper)

+ (UIColor *)bruinColor
{
    return [UIColor colorWithPatternImage:[UIImage imageNamed:@"Pixel.png"]];
}

+ (UIColor *)defaultColor
{
    return [UIColor colorWithRed:25.0/255 green:110.0/255 blue:180.0/255 alpha:1];
}

+ (UIColor *)separatorColor
{
    return [UIColor colorWithRed:25.0/255 green:100.0/255 blue:195.0/255 alpha:0.12];
}

+ (UIColor *)backgroundColor
{
    return [UIColor colorWithRed:237.0/255 green:243.0/255 blue:251.0/255 alpha:1];
}

+ (UIColor *)headerColor
{
    return [UIColor colorWithRed:70.0/255 green:120.0/255 blue:160.0/255 alpha:0.8];
}

@end
