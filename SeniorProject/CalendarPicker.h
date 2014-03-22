//
//  CalendarPicker.h
//  One
//
//  Created by Skylar Peterson on 3/13/14.
//  Copyright (c) 2014 SkylarPeterson. All rights reserved.
//

#import "BlurOverlayView.h"
#import "CalendarCell.h"

@protocol CalendarPickerDelegate <NSObject>

@required
- (void)calendarSelectedFromCell:(CalendarCell *)calendarCell;

@end

@interface CalendarPicker : BlurOverlayView

@property (nonatomic, strong) id<CalendarPickerDelegate> delegate;
@property (nonatomic) BOOL includeNone;
@property (nonatomic, strong) NSArray *calendars;

@end
