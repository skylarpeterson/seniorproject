//
//  Colors.m
//  SeniorProject
//
//  Created by Skylar Peterson on 1/28/14.
//  Copyright (c) 2014 SkylarPeterson. All rights reserved.
//

#import "Colors.h"

@implementation Colors

+ (UIColor *)dividedColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha];
}

+ (UIColor *)mainGrayColor
{
    return [Colors dividedColorWithRed:85.0 green:85.0 blue:85.0 alpha:1.0];
}

+ (UIColor *)completedGrayColor
{
    return [Colors dividedColorWithRed:85.0 green:85.0 blue:85.0 alpha:0.3];
}

+ (UIColor *)secondarGrayColor
{
    return [Colors dividedColorWithRed:55.0 green:55.0 blue:55.0 alpha:1.0];
}

+ (UIColor *)secondarGrayColorFaded
{
    return [Colors dividedColorWithRed:55.0 green:55.0 blue:55.0 alpha:0.25];
}

+ (UIColor *)lightestGrayColor
{
    return [Colors dividedColorWithRed:200.0 green:200.0 blue:200.0 alpha:1.0];
}

+ (UIColor *)secondaryLightestGrayColor
{
    return [Colors dividedColorWithRed:170.0 green:170.0 blue:170.0 alpha:1.0];
}

+ (UIColor *)selectedColor
{
    return [Colors dividedColorWithRed:155.0 green:155.0 blue:155.0 alpha:1.0];
}

+ (UIColor *)emeraldColor
{
    return [Colors dividedColorWithRed:1.0 green:152.0 blue:117.0 alpha:1.0];
}

+ (UIColor *)switchWeekColor
{
    return [Colors dividedColorWithRed:60.0 green:179.0 blue:113.0 alpha:1.0];
}

+ (UIColor *)completeColor
{
    return [Colors dividedColorWithRed:152.0 green:251.0 blue:152.0 alpha:1.0];
}

+ (UIColor *)deleteColor
{
    return [Colors dividedColorWithRed:250.0 green:128.0 blue:148.0 alpha:1.0];
}

@end
