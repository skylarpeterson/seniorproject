//
//  Fonts.h
//  SeniorProject
//
//  Created by Skylar Peterson on 1/27/14.
//  Copyright (c) 2014 SkylarPeterson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Fonts : NSObject

+ (UIFont *)titleFont;
+ (UIFont *)dayBarFont;
+ (UIFont *)dayBarNumberFont;
+ (UIFont *)dayTimesFont;
+ (UIFont *)eventMainTitleFont;
+ (UIFont *)locationFont;
+ (UIFont *)endTimeFont;
+ (UIFont *)weekSwitchFont;

+ (UIFont *)miniTableViewMainFont;
+ (UIFont *)miniTableViewSubFont;

+ (UIFont *)optionsViewUnselectedTabFont;
+ (UIFont *)optionsViewSelectedTabFont;

+ (UIFont *)listItemFont;
+ (UIFont *)showCompletedFont;

+ (UIFont *)addItemTitleFont;
+ (UIFont *)addItemSubtitleFont;
+ (UIFont *)addItemButtonFont;

+ (UIFont *)nextEventComingUpFont;
+ (UIFont *)nextEventTitleFont;
+ (UIFont *)nextEventLocationFont;
+ (UIFont *)nextEventTimeFont;
+ (UIFont *)nextEventTimeDistinctionFont;

@end
