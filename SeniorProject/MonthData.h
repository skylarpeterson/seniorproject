//
//  MonthData.h
//  SeniorProject
//
//  Created by Skylar Peterson on 1/21/14.
//  Copyright (c) 2014 SkylarPeterson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MonthData : NSObject

+ (NSString *)nameForMonth:(NSInteger)month;
+ (NSInteger)daysInMonth:(NSInteger)month inYear:(NSInteger)year;
+ (NSInteger)dayOfTheWeekWithDay:(NSInteger)day inMonth:(NSInteger)month inYear:(NSInteger)year;

@end
