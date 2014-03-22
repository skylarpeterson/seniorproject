//
//  Fonts.m
//  SeniorProject
//
//  Created by Skylar Peterson on 1/27/14.
//  Copyright (c) 2014 SkylarPeterson. All rights reserved.
//

#import "Fonts.h"

@implementation Fonts

+ (UIFont *)titleFont
{
    return [UIFont fontWithName:@"GeosansLight" size:32.0];
}

+ (UIFont *)dayBarFont
{
    return [UIFont fontWithName:@"Quicksand-Regular" size:22.0];
}

+ (UIFont *)dayBarNumberFont
{
    return [UIFont fontWithName:@"Quicksand-Light" size:16.0];
}

+ (UIFont *)dayTimesFont
{
    return [UIFont fontWithName:@"Quicksand-Light" size:16.0];
}

// For main event titles on day view
+ (UIFont *)eventMainTitleFont
{
    return [UIFont fontWithName:@"Quicksand-Regular" size:22.0];
}

+ (UIFont *)locationFont
{
    return [UIFont fontWithName:@"Quicksand-Light" size:18.0];
}

+ (UIFont *)endTimeFont
{
    return [UIFont fontWithName:@"Quicksand-Light" size:13.0];
}

+ (UIFont *)weekSwitchFont
{
    return [UIFont fontWithName:@"Quicksand-Regular" size:24.0];
}

#pragma mark - Mini Table View Fonts

+ (UIFont *)miniTableViewMainFont
{
    return [UIFont fontWithName:@"Quicksand-Regular" size:12.0];
}

+ (UIFont *)miniTableViewSubFont
{
    return [UIFont fontWithName:@"Quicksand-Light" size:8.0];
}

#pragma mark - Options View Fonts

+ (UIFont *)optionsViewUnselectedTabFont
{
    return [UIFont fontWithName:@"Quicksand-Light" size:18.0];
}

+ (UIFont *)optionsViewSelectedTabFont
{
    return [UIFont fontWithName:@"Quicksand-Regular" size:20.0];
}

#pragma mark - List View Fonts

+ (UIFont *)listItemFont
{
    return [UIFont fontWithName:@"Quicksand-Light" size:24.0];
}

+ (UIFont *)showCompletedFont
{
    return [UIFont fontWithName:@"Quicksand-Regular" size:20.0];
}

#pragma mark - Adding View Fonts

+ (UIFont *)addItemTitleFont
{
    return [UIFont fontWithName:@"GeosansLight" size:26.0];
}

+ (UIFont *)addItemSubtitleFont
{
    return [UIFont fontWithName:@"Quicksand-Regular" size:20.0];
}

+ (UIFont *)addItemButtonFont
{
    return [UIFont fontWithName:@"GeosansLight" size:22.0];
}

// Summary Page Fonts

+ (UIFont *)nextEventComingUpFont
{
    return [UIFont fontWithName:@"GeosansLight" size:18.0];
}

+ (UIFont *)nextEventTitleFont
{
    return [UIFont fontWithName:@"Quicksand-Regular" size:28.0];
}

+ (UIFont *)nextEventLocationFont
{
    return [UIFont fontWithName:@"Quicksand-Regular" size:24.0];
}

+ (UIFont *)nextEventTimeFont
{
    return [UIFont fontWithName:@"GeosansLight" size:44.0];
}

+ (UIFont *)nextEventTimeDistinctionFont
{
    return [UIFont fontWithName:@"GeosansLight" size:28.0];
}

@end
