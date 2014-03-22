//
//  CalendarCell.h
//  One
//
//  Created by Skylar Peterson on 2/27/14.
//  Copyright (c) 2014 SkylarPeterson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>

@interface CalendarCell : UITableViewCell

#define INSET 10.0

@property (nonatomic, strong) EKCalendar *calendar;
@property (nonatomic, strong) UIColor *calendarColor;
@property (nonatomic, strong) NSString *calendarName;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic) NSInteger circleSize;

@end
