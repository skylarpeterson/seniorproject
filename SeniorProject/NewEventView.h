//
//  NewEventView.h
//  SeniorProject
//
//  Created by Skylar Peterson on 2/10/14.
//  Copyright (c) 2014 SkylarPeterson. All rights reserved.
//

#import "AddView.h"

@protocol NewEventDelegate <NSObject>

@required
- (void)recurrenceTappedWithContainsCustom:(BOOL)containsCustom;

@end

@interface NewEventView : AddView

@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSString *location;
@property (nonatomic, strong, readonly) EKCalendar *calendar;
@property (nonatomic, readonly) BOOL allDay;
@property (nonatomic, strong, readonly) NSDate *startDateRead;
@property (nonatomic, strong, readonly) NSDate *endDateRead;
@property (nonatomic, strong, readonly) EKRecurrenceRule *recurrenceRule;
@property (nonatomic, readonly) BOOL busy;
@property (nonatomic, strong, readonly) NSString *notes;

@property (nonatomic, strong) id<NewEventDelegate> eventDelegate;
-(void)setRecurrence:(NSString *)recurrence;

@end
