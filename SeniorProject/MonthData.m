//
//  MonthData.m
//  SeniorProject
//
//  Created by Skylar Peterson on 1/21/14.
//  Copyright (c) 2014 SkylarPeterson. All rights reserved.
//

#import "MonthData.h"

@implementation MonthData

+ (BOOL)isLeapYear:(NSInteger)year
{
    if (year % 4 == 0) {
        if (year % 100 == 0) {
            if (year % 400 == 0) return YES;
            else return NO;
        }
        return YES;
    }
    return NO;
}

+ (NSDictionary *)monthsDictionaryForYear:(NSInteger)year
{
    return @{ [NSNumber numberWithInt:0] : [NSNumber numberWithInt:31],
              [NSNumber numberWithInt:1] : ([MonthData isLeapYear:year]) ? [NSNumber numberWithInt:29] : [NSNumber numberWithInt:28],
              [NSNumber numberWithInt:2] : [NSNumber numberWithInt:31],
              [NSNumber numberWithInt:3] : [NSNumber numberWithInt:30],
              [NSNumber numberWithInt:4] : [NSNumber numberWithInt:31],
              [NSNumber numberWithInt:5] : [NSNumber numberWithInt:30],
              [NSNumber numberWithInt:6] : [NSNumber numberWithInt:31],
              [NSNumber numberWithInt:7] : [NSNumber numberWithInt:31],
              [NSNumber numberWithInt:8] : [NSNumber numberWithInt:30],
              [NSNumber numberWithInt:9] : [NSNumber numberWithInt:31],
              [NSNumber numberWithInt:10] : [NSNumber numberWithInt:30],
              [NSNumber numberWithInt:11] : [NSNumber numberWithInt:31]};
}

+ (NSInteger)daysInMonth:(NSInteger)month inYear:(NSInteger)year
{
    NSNumber *days = [[MonthData monthsDictionaryForYear:year] objectForKey:[NSNumber numberWithInteger:month]];
    return days.intValue;
}

+ (NSString *)nameForMonth:(NSInteger)month
{
    switch (month) {
        case 0:
            return @"January";
            break;
        case 1:
            return @"February";
            break;
        case 2:
            return @"March";
            break;
        case 3:
            return @"April";
            break;
        case 4:
            return @"May";
            break;
        case 5:
            return @"June";
            break;
        case 6:
            return @"July";
            break;
        case 7:
            return @"August";
            break;
        case 8:
            return @"September";
            break;
        case 9:
            return @"October";
            break;
        case 10:
            return @"November";
            break;
        case 11:
            return @"December";
            break;
        default:
            return nil;
            break;
    }
}

+ (NSDictionary *)monthsTableForYear:(NSInteger)year
{
    return @{ [NSNumber numberWithInt:0] : ([MonthData isLeapYear:year]) ? [NSNumber numberWithInt:-1] : [NSNumber numberWithInt:0],
              [NSNumber numberWithInt:1] : ([MonthData isLeapYear:year]) ? [NSNumber numberWithInt:2] : [NSNumber numberWithInt:3],
              [NSNumber numberWithInt:2] : [NSNumber numberWithInt:3],
              [NSNumber numberWithInt:3] : [NSNumber numberWithInt:6],
              [NSNumber numberWithInt:4] : [NSNumber numberWithInt:1],
              [NSNumber numberWithInt:5] : [NSNumber numberWithInt:4],
              [NSNumber numberWithInt:6] : [NSNumber numberWithInt:6],
              [NSNumber numberWithInt:7] : [NSNumber numberWithInt:2],
              [NSNumber numberWithInt:8] : [NSNumber numberWithInt:5],
              [NSNumber numberWithInt:9] : [NSNumber numberWithInt:0],
              [NSNumber numberWithInt:10] : [NSNumber numberWithInt:3],
              [NSNumber numberWithInt:11] : [NSNumber numberWithInt:5]};
}

+ (NSInteger)centuryNumForYear:(NSInteger)year
{
    NSInteger num = year / 100;
    switch (num % 4) {
        case 0:
            return 6;
            break;
        case 1:
            return 4;
            break;
        case 2:
            return 2;
            break;
        case 3:
            return 0;
            break;
        default:
            return -1;
            break;
    }
}

+ (NSInteger)dayOfTheWeekWithDay:(NSInteger)day inMonth:(NSInteger)month inYear:(NSInteger)year
{
    NSNumber *m = [[MonthData monthsTableForYear:year] objectForKey:[NSNumber numberWithInteger:month]];
    NSInteger y = year % 100;
    NSInteger c = [MonthData centuryNumForYear:year];
    return (int)(day + m.intValue + y + floor(y/4) + c) % 7;
}


@end
