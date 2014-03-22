//
//  CalInfo.m
//  SeniorProject
//
//  Created by Skylar Peterson on 2/8/14.
//  Copyright (c) 2014 SkylarPeterson. All rights reserved.
//

#import "CalInfo.h"

@implementation CalInfo

+ (NSString *)dayOfTheWeekForDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)dayOfTheWeekForDayNum:(NSInteger)dayNum
{
    return [[CalInfo weekdaysForNums] objectForKey:[NSNumber numberWithInteger:dayNum]];
}

+ (NSInteger)dayNumForDate:(NSDate *)date
{
    NSString *weekday = [CalInfo dayOfTheWeekForDate:date];
    NSNumber *weekdayNum = [[CalInfo weekdayNums] objectForKey:weekday];
    return weekdayNum.integerValue;
}

+ (NSInteger)dayNumForDay:(NSString *)day
{
    NSNumber *weekdayNum = [[CalInfo weekdayNums] objectForKey:day];
    return weekdayNum.integerValue;
}

+ (NSDictionary *)weekdaysForNums
{
    return @{ [NSNumber numberWithInt:0] : @"Sunday",
              [NSNumber numberWithInt:1] : @"Monday",
              [NSNumber numberWithInt:2] :@"Tuesday",
              [NSNumber numberWithInt:3] : @"Wednesday",
              [NSNumber numberWithInt:4] : @"Thursday",
              [NSNumber numberWithInt:5] : @"Friday",
              [NSNumber numberWithInt:6] : @"Saturday"};
}

+ (NSDictionary *)weekdayNums
{
    return @{ @"Sunday" : [NSNumber numberWithInt:0],
              @"Monday" : [NSNumber numberWithInt:1],
              @"Tuesday" : [NSNumber numberWithInt:2],
              @"Wednesday" : [NSNumber numberWithInt:3],
              @"Thursday" : [NSNumber numberWithInt:4],
              @"Friday" : [NSNumber numberWithInt:5],
              @"Saturday" : [NSNumber numberWithInt:6]};
}

+ (NSInteger)dateForNSDate:(NSDate *)date
{
    NSArray *dateItems = [CalInfo dateComponentsForDate:date];
    return [[dateItems objectAtIndex:1] integerValue];
}

+ (NSArray *)dateComponentsForDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"MM/dd/yyyy";
    return [[dateFormatter stringFromDate:date] componentsSeparatedByString:@"/"];
}

+ (NSArray *)weekDayNumsForWeekWithDate:(NSDate *)date
{
    NSMutableArray *weekDayNums = [[NSMutableArray alloc] initWithCapacity:7];
    
    NSArray *dateItems = [CalInfo dateComponentsForDate:date];
    
    NSInteger dateNum = [(NSString *)[dateItems objectAtIndex:1] integerValue];
    NSInteger monthNum = [(NSString *)[dateItems objectAtIndex:0] integerValue];
    NSInteger yearNum = [(NSString *)[dateItems objectAtIndex:2] integerValue];
    
    NSInteger dayNum = [CalInfo dayNumForDate:date];
    [weekDayNums addObject:[NSNumber numberWithInteger:dateNum]];
    
    NSInteger daysInDateMonth = [CalInfo daysInMonth:monthNum inYear:yearNum];
    NSInteger daysInPreviousMonth;
    if (monthNum == 1) daysInPreviousMonth = [CalInfo daysInMonth:12 inYear:yearNum - 1];
    else daysInPreviousMonth = [CalInfo daysInMonth:monthNum - 1 inYear:yearNum];
    
    for (NSInteger i = 0; i < dayNum; i++) {
        NSInteger nextNumber = dateNum + (i - dayNum);
        if (nextNumber < 1) nextNumber += daysInPreviousMonth;
        [weekDayNums insertObject:[NSNumber numberWithInteger:nextNumber] atIndex:i];
    }
    
    for (NSInteger j = dayNum + 1; j < 7; j++) {
        NSInteger nextNumber = dateNum + (j - dayNum);
        if (nextNumber > daysInDateMonth) nextNumber -= daysInDateMonth;
        [weekDayNums insertObject:[NSNumber numberWithInteger:nextNumber] atIndex:j];
    }
    
    return weekDayNums;
}

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
    return @{ [NSNumber numberWithInt:1] : [NSNumber numberWithInt:31],
              [NSNumber numberWithInt:2] : ([CalInfo isLeapYear:year]) ? [NSNumber numberWithInt:29] : [NSNumber numberWithInt:28],
              [NSNumber numberWithInt:3] : [NSNumber numberWithInt:31],
              [NSNumber numberWithInt:4] : [NSNumber numberWithInt:30],
              [NSNumber numberWithInt:5] : [NSNumber numberWithInt:31],
              [NSNumber numberWithInt:6] : [NSNumber numberWithInt:30],
              [NSNumber numberWithInt:7] : [NSNumber numberWithInt:31],
              [NSNumber numberWithInt:8] : [NSNumber numberWithInt:31],
              [NSNumber numberWithInt:9] : [NSNumber numberWithInt:30],
              [NSNumber numberWithInt:10] : [NSNumber numberWithInt:31],
              [NSNumber numberWithInt:11] : [NSNumber numberWithInt:30],
              [NSNumber numberWithInt:12] : [NSNumber numberWithInt:31]};
}

+ (NSInteger)daysInMonth:(NSInteger)month inYear:(NSInteger)year
{
    NSNumber *days = [[CalInfo monthsDictionaryForYear:year] objectForKey:[NSNumber numberWithInteger:month]];
    return days.intValue;
}

+ (NSString *)monthShorteningForDate:(NSDate *)date
{
    NSArray *dateItems = [CalInfo dateComponentsForDate:date];
    NSString *monthName = [CalInfo nameForMonth:[[dateItems objectAtIndex:0] integerValue]];
    return [NSString stringWithFormat:@"%@.", [monthName substringToIndex:3]];
}

+ (NSString *)nameForMonth:(NSInteger)month
{
    switch (month) {
        case 1:
            return @"January";
            break;
        case 2:
            return @"February";
            break;
        case 3:
            return @"March";
            break;
        case 4:
            return @"April";
            break;
        case 5:
            return @"May";
            break;
        case 6:
            return @"June";
            break;
        case 7:
            return @"July";
            break;
        case 8:
            return @"August";
            break;
        case 9:
            return @"September";
            break;
        case 10:
            return @"October";
            break;
        case 11:
            return @"November";
            break;
        case 12:
            return @"December";
            break;
        default:
            return nil;
            break;
    }
}

+ (NSString *)yearForDate:(NSDate *)date
{
    NSArray *dateItems = [CalInfo dateComponentsForDate:date];
    return [dateItems objectAtIndex:2];
}

+ (NSString *)timeStringFromDate:(NSDate *)date with12HourFormat:(BOOL)twelveHour
{
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
    if (twelveHour) timeFormatter.dateFormat = @"hh:mma";
    else timeFormatter.dateFormat = @"HH:mma";
    NSString *str = [timeFormatter stringFromDate:date];
    if ([str characterAtIndex:0] == '0') {
        str = [str substringFromIndex:1];
    }
    
    return str;
}

+ (NSString *)adjustedTimeStringFromDate:(NSDate *)date with12HourFormat:(BOOL)twelveHour
{
    NSString *str = [CalInfo timeStringFromDate:date with12HourFormat:twelveHour];
    NSString *val;
    if ([str characterAtIndex:1] == ':') {
        val = [str substringWithRange:NSMakeRange(2, 2)];
        if (val.intValue != 0) {
            int newInt = [str substringWithRange:NSMakeRange(0, 1)].intValue;
            str = [NSString stringWithFormat:@"%i:00%@", newInt, [str substringWithRange:NSMakeRange(4, 2)]];
        }
    } else {
        val = [str substringWithRange:NSMakeRange(3, 2)];
        if (val.intValue != 0) {
            int newInt = [str substringWithRange:NSMakeRange(0, 2)].intValue;
            str = [NSString stringWithFormat:@"%i:00%@", newInt, [str substringWithRange:NSMakeRange(5, 2)]];
        }
    }
    
    return str;
}

+ (NSArray *)dateStringArrayForDate:(NSDate *)date
{
    NSMutableArray *arr = [[CalInfo dateComponentsForDate:date] mutableCopy];
    [arr removeObjectAtIndex:0];
    [arr insertObject:[[CalInfo monthShorteningForDate:date] substringToIndex:3] atIndex:0];
    
    NSString *day = [arr objectAtIndex:1];
    if ([day characterAtIndex:0] == '0') {
        day = [day substringFromIndex:1];
        [arr removeObjectAtIndex:1];
        [arr insertObject:day atIndex:1];
    }
    return [arr copy];
}

+ (NSArray *)monthStrings
{
    NSMutableArray *mutableMonths = [[NSMutableArray alloc] init];
    for (int i = 1; i <= 12; i++) {
        [mutableMonths addObject:[[CalInfo nameForMonth:i] substringToIndex:3]];
    }
    return [mutableMonths copy];
}

+ (NSArray *)dayStringsForMonth:(NSInteger)month inYear:(NSInteger)year
{
    NSMutableArray *mutableDays = [[NSMutableArray alloc] init];
    for (int i = 1; i <= [CalInfo daysInMonth:month inYear:year]; i++) {
        [mutableDays addObject:[NSString stringWithFormat:@"%i", i]];
    }
    return [mutableDays copy];
}

+ (NSArray *)yearStringsStartingOnDate:(NSDate *)date withNumStrings:(NSInteger)numStrings
{
    NSMutableArray *mutableYears = [[NSMutableArray alloc] init];
    int currYear = [CalInfo yearForDate:date].intValue;
    for (int i = 0; i < numStrings; i++) {
        [mutableYears addObject:[NSString stringWithFormat:@"%i", currYear + i]];
    }
    return [mutableYears copy];
}

#pragma Date Creation Methods

+ (NSDate *)dateWithMonth:(NSString *)month andDay:(NSString *)day andYear:(NSString *)year
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
    NSDate *date = [formatter dateFromString:[NSString stringWithFormat:@"%@/%@/%@ 12:00 AM", month, day, year]];
    return date;
}

+ (NSDate *)dateWithMonth:(NSString *)month andDay:(NSString *)day andYear:(NSString *)year andTime:(NSString *)time
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
    NSDate *date = [formatter dateFromString:[NSString stringWithFormat:@"%@/%@/%@ %@", month, day, year, time]];
    return date;
}

@end
