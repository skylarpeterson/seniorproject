//
//  CalInfo.h
//  SeniorProject
//
//  Created by Skylar Peterson on 2/8/14.
//  Copyright (c) 2014 SkylarPeterson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalInfo : NSObject

+ (NSString *)dayOfTheWeekForDate:(NSDate *)date;
+ (NSString *)dayOfTheWeekForDayNum:(NSInteger)dayNum;

+ (NSInteger)dayNumForDate:(NSDate *)date;
+ (NSInteger)dayNumForDay:(NSString *)day;


+ (NSInteger)dateForNSDate:(NSDate *)date;

+ (NSArray *)dateComponentsForDate:(NSDate *)date;
+ (NSArray *)weekDayNumsForWeekWithDate:(NSDate *)date;

+ (NSString *)monthShorteningForDate:(NSDate *)date;
+ (NSString *)yearForDate:(NSDate *)date;

+ (NSString *)timeStringFromDate:(NSDate *)date with12HourFormat:(BOOL)twelveHour;
+ (NSString *)adjustedTimeStringFromDate:(NSDate *)date with12HourFormat:(BOOL)twelveHour;

+ (NSArray *)dateStringArrayForDate:(NSDate *)date;
+ (NSArray *)monthStrings;
+ (NSArray *)dayStringsForMonth:(NSInteger)month inYear:(NSInteger)year;
+ (NSArray *)yearStringsStartingOnDate:(NSDate *)date withNumStrings:(NSInteger)numStrings;

+ (NSDate *)dateWithMonth:(NSString *)month andDay:(NSString *)day andYear:(NSString *)year;
+ (NSDate *)dateWithMonth:(NSString *)month andDay:(NSString *)day andYear:(NSString *)year andTime:(NSString *)time;

+ (NSDictionary *)weekdaysForNums;

@end
