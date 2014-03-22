//
//  AddItemViewController.m
//  One
//
//  Created by Skylar Peterson on 3/13/14.
//  Copyright (c) 2014 SkylarPeterson. All rights reserved.
//

#import "AddItemViewController.h"
#import "CalendarPicker.h"
#import "RecurrencePicker.h"

#import "NewEventView.h"
#import "NewTaskView.h"

#import "Colors.h"

@interface AddItemViewController () < AddViewDelegate, CalendarPickerDelegate, RecurrencePickerDelegate, NewEventDelegate>

@property (nonatomic, strong) CalendarPicker *picker;
@property (nonatomic, strong) RecurrencePicker *recurrencePicker;

@end

@implementation AddItemViewController

#define UNWIND_EVENT_SEGUE_IDENTIFIER @"AddEvent"
#define UNWIND_LIST_SEGUE_IDENIFIER @"AddItem"

#pragma mark - View Loading

#define ADD_VIEW_INSET 5.0
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    
    self.addView.frame = CGRectMake(ADD_VIEW_INSET, 20.0, self.view.frame.size.width - 2*ADD_VIEW_INSET, self.view.frame.size.height - 20.0 - ADD_VIEW_INSET);
    self.addView.delegate = self;
    
    if ([self.addView isKindOfClass:[NewEventView class]]) {
        ((NewEventView *)self.addView).eventDelegate = self;
    }
    
    [self.view addSubview:self.addView];
}

#pragma mark - Add View Delegate Methods

- (void)createTapped
{
    if ([self.addView isKindOfClass:[NewEventView class]]) {
        [self performSegueWithIdentifier:UNWIND_EVENT_SEGUE_IDENTIFIER sender:self];
    } else if ([self.addView isKindOfClass:[NewTaskView class]]) {
        [self performSegueWithIdentifier:UNWIND_LIST_SEGUE_IDENIFIER sender:self];
    }
}

- (void)cancelTapped
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Add Task Delegate Methods

- (void)calendarCellTapped
{
    self.picker = [[CalendarPicker alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
    self.picker.alpha = 0.0;
    self.picker.delegate = self;
    if ([self.addView isKindOfClass:[NewEventView class]]) self.picker.includeNone = NO;
    else if ([self.addView isKindOfClass:[NewTaskView class]]) self.picker.includeNone = YES;
    self.picker.calendars = self.calendars;
    self.picker.textColor = self.addView.calendarCell.textColor;
    [self.view addSubview:self.picker];

    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.picker.alpha = 1.0;
                     }completion:nil];
}

#pragma mark - Calendar Picker Delegate Methods

- (void)calendarSelectedFromCell:(CalendarCell *)calendarCell
{
    self.addView.calendarCell.calendarName = calendarCell.calendarName;
    self.addView.calendarCell.calendarColor = calendarCell.calendarColor;
    self.addView.calendarCell.calendar = calendarCell.calendar;
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                        self.picker.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [self.picker removeFromSuperview];
                         }
                     }];
}

#pragma mark - New Event View Delegate Methods

- (void)recurrenceTappedWithContainsCustom:(BOOL)containsCustom
{
    self.recurrencePicker = [[RecurrencePicker alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
    self.recurrencePicker.alpha = 0.0;
    self.recurrencePicker.delegate = self;
    self.recurrencePicker.textColor = [Colors lightestGrayColor];
    self.recurrencePicker.containsCustom = containsCustom;
    [self.view addSubview:self.recurrencePicker];
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.recurrencePicker.alpha = 1.0;
                     }completion:nil];
}

- (void)recurrencePicked:(UITableViewCell *)cell
{
    [((NewEventView *)self.addView) setRecurrence:cell.textLabel.text];
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.recurrencePicker.alpha = 0.0;
                     }completion:^(BOOL finished){
                         if (finished) {
                             [self.recurrencePicker removeFromSuperview];
                         }
                     }];
}

@end
