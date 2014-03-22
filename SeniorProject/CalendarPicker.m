//
//  CalendarPicker.m
//  One
//
//  Created by Skylar Peterson on 3/13/14.
//  Copyright (c) 2014 SkylarPeterson. All rights reserved.
//

#import "CalendarPicker.h"
#import <EventKit/EventKit.h>

#import "Fonts.h"
#import "Colors.h"
#import "Methods.h"

@interface CalendarPicker()

@property (nonatomic, strong) NSArray *sources;
@property (nonatomic, strong) NSDictionary *calendarsForSource;

@end

@implementation CalendarPicker

- (void)setCalendars:(NSArray *)calendars
{
    _calendars = calendars;
    NSMutableArray *mutableSources = [[NSMutableArray alloc] init];
    NSMutableDictionary *mutableCalendars = [[NSMutableDictionary alloc] init];
    for (EKCalendar *calendar in calendars) {
        EKSource *source = calendar.source;
        if (![mutableSources containsObject:source]) [mutableSources addObject:source];
        if (![mutableCalendars objectForKey:source.sourceIdentifier]) {
            NSMutableArray *calendarArray = [[NSMutableArray alloc] initWithArray:@[calendar]];
            [mutableCalendars setObject:calendarArray forKey:source.sourceIdentifier];
        } else {
            NSMutableArray *calendarArray = [mutableCalendars objectForKey:source.sourceIdentifier];
            [calendarArray addObject:calendar];
            [mutableCalendars setObject:calendarArray forKey:source.sourceIdentifier];
        }
    }
    
    mutableSources = [[mutableSources sortedArrayUsingComparator: ^NSComparisonResult(EKSource *first, EKSource *second){
        return [first.title caseInsensitiveCompare:second.title];
    }] mutableCopy];
    if (self.includeNone) [mutableSources insertObject:@"None" atIndex:0];
    self.sources = [mutableSources copy];
    self.calendarsForSource = [mutableCalendars copy];
}

#define CALENDAR_CELL_IDENTIFIER @"CalendarCell"
- (void)initialize
{
    [super initialize];
    [self.tableView registerClass:[CalendarCell class] forCellReuseIdentifier:CALENDAR_CELL_IDENTIFIER];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

#pragma mark - Table View Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sources count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.frame.size.width, 30.0)];
    view.backgroundColor = [Colors secondarGrayColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, view.frame.size.width, 30.0)];
    if ([[self.sources objectAtIndex:section] isKindOfClass:[EKSource class]]) {
        EKSource *source = [self.sources objectAtIndex:section];
        label.text = source.title;
    } else {
        label.text = @"Default";
    }
    label.textColor = [Colors lightestGrayColor];
    label.font = [Fonts showCompletedFont];
    [view addSubview:label];
    
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[self.sources objectAtIndex:section] isKindOfClass:[EKSource class]]) {
        EKSource *source = [self.sources objectAtIndex:section];
        NSMutableArray *calendarArray = [self.calendarsForSource objectForKey:source.sourceIdentifier];
        return [calendarArray count];
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *calendarTitle;
    if ([[self.sources objectAtIndex:indexPath.section] isKindOfClass:[EKSource class]]) {
        EKSource *source = [self.sources objectAtIndex:indexPath.section];
        NSMutableArray *calendarArray = [self.calendarsForSource objectForKey:source.sourceIdentifier];
        EKCalendar *calendar = [calendarArray objectAtIndex:indexPath.row];
        calendarTitle = calendar.title;
    } else {
        calendarTitle = @"None";
    }
    CGSize textSize = [Methods sizeForText:calendarTitle withWidth:self.tableView.frame.size.width - 20.0 - INSET andFont:[Fonts listItemFont]];
    return textSize.height + 40.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarCell *cell = (CalendarCell *)[self.tableView dequeueReusableCellWithIdentifier:CALENDAR_CELL_IDENTIFIER forIndexPath:indexPath];
    
    NSString *calendarTitle;
    if ([[self.sources objectAtIndex:indexPath.section] isKindOfClass:[EKSource class]]) {
        EKSource *source = [self.sources objectAtIndex:indexPath.section];
        NSMutableArray *calendarArray = [self.calendarsForSource objectForKey:source.sourceIdentifier];
        EKCalendar *calendar = [calendarArray objectAtIndex:indexPath.row];
        calendarTitle = calendar.title;
        cell.calendarColor = [UIColor colorWithCGColor:calendar.CGColor];
        cell.calendar = calendar;
    } else {
        calendarTitle = @"None";
        cell.calendarColor = [Colors mainGrayColor];
        cell.calendar = nil;
    }
    cell.font = [Fonts listItemFont];
    cell.calendarName = calendarTitle;
    cell.textColor = self.textColor;
    cell.circleSize = 20.0;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - Table View Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate calendarSelectedFromCell:(CalendarCell *)[self.tableView cellForRowAtIndexPath:indexPath]];
}

@end
