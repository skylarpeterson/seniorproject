//
//  NewEventView.m
//  SeniorProject
//
//  Created by Skylar Peterson on 2/10/14.
//  Copyright (c) 2014 SkylarPeterson. All rights reserved.
//

#import "NewEventView.h"
#import "OptionsView.h"
#import "DayRepeatingView.h"
#import "DatePickerView.h"
#import "TimePickerView.h"

#import "Colors.h"
#import "Methods.h"
#import "CalInfo.h"

@interface NewEventView() <UITextViewDelegate, OptionsViewDelegate, PickerDelegate>

@property (nonatomic, strong) UILabel *eventTitleLabel;
@property (nonatomic, strong) UITextView *titleTextView;
@property (nonatomic, strong) UILabel *eventLocationLabel;
@property (nonatomic, strong) UITextView *locationTextView;
@property (nonatomic, strong) UILabel *calendarLabel;
@property (nonatomic, strong) OptionsView *allDayView;
@property (nonatomic, strong) UILabel *startDateLabel;
@property (nonatomic, strong) DatePickerView *startDate;
@property (nonatomic, strong) TimePickerView *startTime;
@property (nonatomic, strong) UILabel *endDateLabel;
@property (nonatomic, strong) DatePickerView *endDate;
@property (nonatomic, strong) TimePickerView *endTime;
@property (nonatomic, strong) UILabel *repeatLabel;
@property (nonatomic, strong) UITableViewCell *repeatCell;
@property (nonatomic, strong) OptionsView *busyView;
@property (nonatomic, strong) UILabel *notesLabel;
@property (nonatomic, strong) UITextView *notesTextView;

@property (nonatomic, strong) UILabel *endRecurrenceDateLabel;
@property (nonatomic, strong) DatePickerView *endRecurrenceDatePicker;
@property (nonatomic, strong) UITableViewCell *secondRepeatCell;
@property (nonatomic, strong) DayRepeatingView *dayRepeatingView;

@property (nonatomic, strong) NSMutableArray *views;
@property (nonatomic) CGSize currentTitleTextSize;
@property (nonatomic) CGSize currentLocationTextSize;
@property (nonatomic) BOOL notesEditing;
@property (nonatomic) BOOL changingMainRecurrence;
@property (nonatomic) BOOL addedCustom;
@property (nonatomic) BOOL addedRecurrenceViews;

@end

@implementation NewEventView

#pragma mark - Readonly Properties

- (NSString *)title
{
    return self.titleTextView.text;
}

- (NSString *)location
{
    return self.locationTextView.text;
}

- (EKCalendar *)calendar
{
    return self.calendarCell.calendar;
}

- (BOOL)allDay
{
    if(self.allDayView.selectedIndex == 0) return NO;
    else return YES;
}

- (NSDate *)startDateRead
{
    return [CalInfo dateWithMonth:[NSString stringWithFormat:@"%li", (long)self.startDate.monthNum] andDay:[self.startDate.options objectAtIndex:1] andYear:[self.startDate.options objectAtIndex:2] andTime:[NSString stringWithFormat:@"%@:%@ %@", [self.startTime.options objectAtIndex:0], [self.startTime.options objectAtIndex:1], [self.startTime.options objectAtIndex:2]]];
}

- (NSDate *)endDateRead
{
    return [CalInfo dateWithMonth:[NSString stringWithFormat:@"%li", (long)self.endDate.monthNum] andDay:[self.endDate.options objectAtIndex:1] andYear:[self.endDate.options objectAtIndex:2] andTime:[NSString stringWithFormat:@"%@:%@ %@", [self.endTime.options objectAtIndex:0], [self.endTime.options objectAtIndex:1], [self.endTime.options objectAtIndex:2]]];
}

- (EKRecurrenceRule *)recurrence
{
    if ([self.repeatCell.textLabel.text isEqualToString:@"None"]) {
        return nil;
    } else if ([self.repeatCell.textLabel.text isEqualToString:@"Every 2 Weeks"]) {
        EKRecurrenceRule *rule = [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyWeekly interval:2 end:nil];
        return rule;
    } else if ([self.repeatCell.textLabel.text isEqualToString:@"Custom"]) {
        return nil;
    } else {
        EKRecurrenceFrequency frequency;
        if ([self.repeatCell.textLabel.text isEqualToString:@"Every Day"]) frequency = EKRecurrenceFrequencyDaily;
        else if ([self.repeatCell.textLabel.text isEqualToString:@"Every Week"]) frequency = EKRecurrenceFrequencyWeekly;
        else if ([self.repeatCell.textLabel.text isEqualToString:@"Every Month"]) frequency = EKRecurrenceFrequencyMonthly;
        else frequency = EKRecurrenceFrequencyYearly;
        EKRecurrenceRule *rule = [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:frequency interval:1 end:nil];
        return rule;
    }
}

- (BOOL)busy
{
    if (self.busyView.selectedIndex == 0) return YES;
    else return NO;
}

- (NSString *)notes
{
    return self.notesTextView.text;
}

#pragma mark - Getters

- (NSMutableArray *)views
{
    if (!_views) _views = [[NSMutableArray alloc] init];
    return _views;
}

- (DayRepeatingView *)dayRepeatingView
{
    if (!_dayRepeatingView) _dayRepeatingView = [[DayRepeatingView alloc] init];
    return _dayRepeatingView;
}

- (DatePickerView *)startDate
{
    if (!_startDate) _startDate = [[DatePickerView alloc] initWithDate:[NSDate date]];
    return _startDate;
}

- (TimePickerView *)startTime
{
    if (!_startTime) _startTime = [[TimePickerView alloc] initWithTime:[CalInfo adjustedTimeStringFromDate:[NSDate date] with12HourFormat:YES]];
    return _startTime;
}

- (DatePickerView *)endDate
{
    if (!_endDate) _endDate = [[DatePickerView alloc] initWithDate:[NSDate date]];
    return _endDate;
}

- (TimePickerView *)endTime
{
    if (!_endTime) _endTime = [[TimePickerView alloc] initWithTime:[CalInfo adjustedTimeStringFromDate:[NSDate date] with12HourFormat:YES]];
    return _endTime;
}

- (void)initialize
{
    self.backgroundColor = [Colors mainGrayColor];
    self.titleText = @"Add New Event";
    self.textColor = [Colors lightestGrayColor];
    
    self.eventTitleLabel = [self labelWithText:@"Event Title:"];
    self.titleTextView = [self newTextView];
    self.eventLocationLabel = [self labelWithText:@"Event Location:"];
    self.locationTextView = [self newTextView];
    
    self.calendarLabel = [self labelWithText:@"Calendar:"];
    self.calendarCell.calendarColor = [Colors lightestGrayColor];
    self.calendarCell.textColor = [Colors lightestGrayColor];
    self.calendarCell.backgroundColor = [Colors secondarGrayColor];

    self.allDayView = [[OptionsView alloc] init];
    self.allDayView.delegate = self;
    self.allDayView.options = @[@"Single Event", @"All Day"];
    self.allDayView.textColor = [Colors lightestGrayColor];
    self.allDayView.unselectedColor = [Colors mainGrayColor];
    self.allDayView.backgroundColor = [Colors secondarGrayColor];
    self.allDayView.selectedIndex = 0;
    
    self.startDateLabel = [self labelWithText:@"Start Date and Time:"];
    self.startDate.delegate = self;
    self.startDate.mainColor = [Colors mainGrayColor];
    self.startDate.selectedColor = [Colors secondarGrayColor];
    self.startDate.textColor = [Colors lightestGrayColor];
    self.startTime.delegate = self;
    self.startTime.mainColor = [Colors mainGrayColor];
    self.startTime.selectedColor = [Colors secondarGrayColor];
    self.startTime.textColor = [Colors lightestGrayColor];
    
    self.endDateLabel = [self labelWithText:@"End Date and Time:"];
    self.endDate.delegate = self;
    self.endDate.mainColor = [Colors mainGrayColor];
    self.endDate.selectedColor = [Colors secondarGrayColor];
    self.endDate.textColor = [Colors lightestGrayColor];
    self.endTime.delegate = self;
    self.endTime.mainColor = [Colors mainGrayColor];
    self.endTime.selectedColor = [Colors secondarGrayColor];
    self.endTime.textColor = [Colors lightestGrayColor];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(repeatCellTapped:)];
    self.repeatLabel = [self labelWithText:@"Repeat:"];
    self.repeatCell = [self recurrenceCell];
    [self.repeatCell addGestureRecognizer:tapGesture];
    
    self.busyView = [[OptionsView alloc] init];
    self.busyView.delegate = self;
    self.busyView.options = @[@"Busy", @"Free"];
    self.busyView.textColor = [Colors lightestGrayColor];
    self.busyView.unselectedColor = [Colors mainGrayColor];
    self.busyView.backgroundColor = [Colors secondarGrayColor];
    self.busyView.selectedIndex = 0;
    
    self.notesLabel = [self labelWithText:@"Notes:"];
    self.notesTextView = [self newTextView];
    self.notesTextView.scrollEnabled = YES;
    
    [self.scrollView addSubview:self.eventTitleLabel];
    [self.views addObject:self.eventTitleLabel];
    [self.scrollView addSubview:self.titleTextView];
    [self.views addObject:self.titleTextView];
    [self.scrollView addSubview:self.eventLocationLabel];
    [self.views addObject:self.eventLocationLabel];
    [self.scrollView addSubview:self.locationTextView];
    [self.views addObject:self.locationTextView];
    [self.scrollView addSubview:self.calendarLabel];
    [self.views addObject:self.calendarLabel];
    [self.views addObject:self.calendarCell];
    [self.scrollView addSubview:self.allDayView];
    [self.views addObject:self.allDayView];
    [self.scrollView addSubview:self.startDateLabel];
    [self.views addObject:self.startDateLabel];
    [self.scrollView addSubview:self.startDate];
    [self.views addObject:self.startDate];
    [self.scrollView addSubview:self.startTime];
    [self.views addObject:self.startTime];
    [self.scrollView addSubview:self.endDateLabel];
    [self.views addObject:self.endDateLabel];
    [self.scrollView addSubview:self.endDate];
    [self.views addObject:self.endDate];
    [self.scrollView addSubview:self.endTime];
    [self.views addObject:self.endTime];
    [self.scrollView addSubview:self.repeatLabel];
    [self.views addObject:self.repeatLabel];
    [self.scrollView addSubview:self.repeatCell];
    [self.views addObject:self.repeatCell];
    [self.scrollView addSubview:self.busyView];
    [self.views addObject:self.busyView];
    [self.scrollView addSubview:self.notesLabel];
    [self.views addObject:self.notesLabel];
    [self.scrollView addSubview:self.notesTextView];
    [self.views addObject:self.notesTextView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (UITextView *)newTextView
{
    UITextView *textView = [[UITextView alloc] init];
    textView.tintColor = [Colors lightestGrayColor];
    textView.delegate = self;
    textView.scrollEnabled = NO;
    textView.layer.cornerRadius = 5.0;
    textView.textColor = [Colors lightestGrayColor];
    textView.font = self.eventTitleLabel.font;
    textView.backgroundColor = [Colors secondarGrayColor];
    textView.returnKeyType = UIReturnKeyDone;
    [textView setTextContainerInset:UIEdgeInsetsMake(1.0, 1.0, 1.0, 1.0)];
    return textView;
}

- (UITableViewCell *)recurrenceCell
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = @"Never";
    cell.textLabel.textColor = [Colors lightestGrayColor];
    cell.textLabel.font = self.eventTitleLabel.font;
    cell.backgroundColor = [Colors secondarGrayColor];
    return cell;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

#define OPTIONS_HEIGHT 50.0
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.eventTitleLabel.frame = CGRectMake(DIVIDE_INSET, 0.0, self.frame.size.width - 2*DIVIDE_INSET, [Methods sizeForText:self.eventTitleLabel.text withWidth:self.frame.size.width - 2 * DIVIDE_INSET andFont:self.eventTitleLabel.font].height);
    self.titleTextView.frame = CGRectMake(DIVIDE_INSET, self.eventTitleLabel.frame.origin.y + self.eventTitleLabel.frame.size.height + DIVIDE_INSET, self.frame.size.width - 2*DIVIDE_INSET, self.eventTitleLabel.frame.size.height + DIVIDE_INSET/2.0);
    self.currentTitleTextSize = [Methods sizeForText:@"text" withWidth:self.titleTextView.frame.size.width andFont:self.titleTextView.font];
    
    self.eventLocationLabel.frame = CGRectMake(DIVIDE_INSET, self.titleTextView.frame.origin.y + self.titleTextView.frame.size.height + DIVIDE_INSET, self.frame.size.width - 2*DIVIDE_INSET, self.eventTitleLabel.frame.size.height);
    self.locationTextView.frame = CGRectMake(DIVIDE_INSET, self.eventLocationLabel.frame.origin.y + self.eventLocationLabel.frame.size.height + DIVIDE_INSET, self.frame.size.width - 2*DIVIDE_INSET, self.eventLocationLabel.frame.size.height + DIVIDE_INSET/2.0);
    self.currentLocationTextSize = [Methods sizeForText:@"text" withWidth:self.locationTextView.frame.size.width andFont:self.locationTextView.font];
    
    self.calendarLabel.frame = CGRectMake(DIVIDE_INSET, self.locationTextView.frame.origin.y + self.locationTextView.frame.size.height + DIVIDE_INSET, self.frame.size.width - 2*DIVIDE_INSET, self.eventLocationLabel.frame.size.height);
    self.calendarCell.frame = CGRectMake(0.0, self.calendarLabel.frame.origin.y + self.calendarLabel.frame.size.height + DIVIDE_INSET, self.frame.size.width, self.calendarLabel.frame.size.height + 2*DIVIDE_INSET);
    self.allDayView.frame = CGRectMake(0.0, self.calendarCell.frame.origin.y + self.calendarCell.frame.size.height + DIVIDE_INSET, self.frame.size.width, OPTIONS_HEIGHT);
    self.startDateLabel.frame = CGRectMake(DIVIDE_INSET, self.allDayView.frame.origin.y + self.allDayView.frame.size.height + DIVIDE_INSET, self.frame.size.width - 2*DIVIDE_INSET, self.calendarLabel.frame.size.height);
    self.startDate.frame = CGRectMake(0.0, self.startDateLabel.frame.origin.y + self.startDateLabel.frame.size.height + DIVIDE_INSET, self.frame.size.width, OPTIONS_HEIGHT);
    self.startTime.frame = CGRectMake(0.0, self.startDate.frame.origin.y + self.startDate.frame.size.height + DIVIDE_INSET, self.frame.size.width, OPTIONS_HEIGHT);
    self.endDateLabel.frame = CGRectMake(DIVIDE_INSET, self.startTime.frame.origin.y + self.startTime.frame.size.height + DIVIDE_INSET, self.frame.size.width - 2*DIVIDE_INSET, self.startDateLabel.frame.size.height);
    self.endDate.frame = CGRectMake(0.0, self.endDateLabel.frame.origin.y + self.endDateLabel.frame.size.height + DIVIDE_INSET, self.frame.size.width, OPTIONS_HEIGHT);
    self.endTime.frame = CGRectMake(0.0, self.endDate.frame.origin.y + self.endDate.frame.size.height + DIVIDE_INSET, self.frame.size.width, OPTIONS_HEIGHT);
    self.repeatLabel.frame = CGRectMake(DIVIDE_INSET, self.endTime.frame.origin.y + self.endTime.frame.size.height + DIVIDE_INSET, self.frame.size.width - 2*DIVIDE_INSET, self.endDateLabel.frame.size.height);
    self.repeatCell.frame = CGRectMake(0.0, self.repeatLabel.frame.origin.y + self.repeatLabel.frame.size.height + DIVIDE_INSET, self.frame.size.width, self.endDateLabel.frame.size.height + 2*DIVIDE_INSET);
    self.busyView.frame = CGRectMake(0.0, self.repeatCell.frame.origin.y + self.repeatCell.frame.size.height + DIVIDE_INSET, self.frame.size.width, OPTIONS_HEIGHT);
    self.notesLabel.frame = CGRectMake(DIVIDE_INSET, self.busyView.frame.origin.y + self.busyView.frame.size.height + DIVIDE_INSET, self.frame.size.width - 2*DIVIDE_INSET, self.endDateLabel.frame.size.height);
    self.notesTextView.frame = CGRectMake(DIVIDE_INSET, self.notesLabel.frame.origin.y + self.notesLabel.frame.size.height + DIVIDE_INSET, self.frame.size.width - 2*DIVIDE_INSET, (self.eventTitleLabel.frame.size.height + DIVIDE_INSET/2.0)*5.0);
    
    CGFloat height = 0.0;
    for (UIView *view in self.views) {
        height += view.frame.size.height + DIVIDE_INSET;
    }
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width, height + DIVIDE_INSET);
    
    //self.dayRepeatingView.frame = CGRectMake(0.0, self.allDayView.frame.origin.y + self.allDayView.frame.size.height + DIVIDE_INSET, self.frame.size.width, BUTTON_SIZE);
}

#pragma mark - UITextView Delegate Methods

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView isEqual:self.notesTextView]) {
        self.notesEditing = YES;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView isEqual:self.notesTextView]) {
        self.notesEditing = NO;
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    if ([textView isEqual:self.notesTextView]) return;
    if ([textView.text isEqualToString:@""]) return;
    if ([textView isEqual:self.titleTextView]) {
        CGSize newSize = [Methods sizeForText:self.titleTextView.text withWidth:self.titleTextView.frame.size.width andFont:self.titleTextView.font];
        if (newSize.height > self.currentTitleTextSize.height || newSize.height < self.currentTitleTextSize.height) {
            [self animateChangeOfTextViewHeightForTextView:self.titleTextView andNewSize:newSize];
        }
    } else if ([textView isEqual:self.locationTextView]) {
        CGSize newSize = [Methods sizeForText:self.locationTextView.text withWidth:self.locationTextView.frame.size.width andFont:self.locationTextView.font];
        if (newSize.height > self.currentLocationTextSize.height || newSize.height < self.currentLocationTextSize.height) {
            [self animateChangeOfTextViewHeightForTextView:self.locationTextView andNewSize:newSize];
        }
    }
}

- (void)animateChangeOfTextViewHeightForTextView:(UITextView *)textView andNewSize:(CGSize)newSize
{
    CGFloat change = newSize.height - textView.frame.size.height + INSET/2.0;
    NSInteger index = [self.views indexOfObject:textView];
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         textView.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textView.frame.size.width, newSize.height + INSET/2.0);
                         for (NSInteger i = index + 1; i < [self.views count]; i++) {
                             UIView *view = [self.views objectAtIndex:i];
                             view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y + change, view.frame.size.width, view.frame.size.height);
                         }
                         self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.scrollView.contentSize.height + change);
                     }completion:^(BOOL finished){
                         if (finished) {
                             if ([textView isEqual:self.titleTextView]) self.currentTitleTextSize = newSize;
                             else if ([textView isEqual:self.locationTextView]) self.currentLocationTextSize = newSize;
                         }
                     }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    return YES;
}

#pragma mark - Options View Delegate Methods

- (void)selectedIndexChangedToIndex:(NSInteger)index
{
    if (self.allDayView.selectedIndex == 1) {
        self.startTime.userInteractionEnabled = NO;
        self.startTime.alpha = 0.5;
        self.endTime.userInteractionEnabled = NO;
        self.endTime.alpha = 0.5;
    } else if (self.allDayView.selectedIndex == 0) {
        self.startTime.userInteractionEnabled = YES;
        self.startTime.alpha = 1.0;
        self.endTime.userInteractionEnabled = YES;
        self.endTime.alpha = 1.0;
    }
}

#pragma mark - Picker View Delegate Methods

#define EXPANDING_MULTIPLIER 5.0
- (void)pickerExpanding:(UIView *)picker
{
    NSInteger index = [self.views indexOfObject:picker];
    CGFloat expandingSize = EXPANDING_MULTIPLIER * picker.frame.size.height - picker.frame.size.height;
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         for (NSInteger i = index + 1; i < [self.views count]; i++) {
                             UIView *view = [self.views objectAtIndex:i];
                             view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y + expandingSize, view.frame.size.width, view.frame.size.height);
                         }
                         picker.frame = CGRectMake(picker.frame.origin.x, picker.frame.origin.y, picker.frame.size.width, EXPANDING_MULTIPLIER * picker.frame.size.height);
                         self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.scrollView.contentSize.height + expandingSize);
                     }completion:^(BOOL finished){
                         if (finished) {
                             [self.scrollView scrollRectToVisible:picker.frame animated:YES];
                             [(PickerView *)picker finishedExpanding];
                         }
                     }];
}

- (void)pickerShrinking:(UIView *)picker
{
    NSInteger index = [self.views indexOfObject:picker];
    CGFloat shrinkingSize = picker.frame.size.height - picker.frame.size.height/EXPANDING_MULTIPLIER;
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         for (NSInteger i = index + 1; i < [self.views count]; i++) {
                             UIView *view = [self.views objectAtIndex:i];
                             view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y - shrinkingSize, view.frame.size.width, view.frame.size.height);
                         }
                         self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.scrollView.contentSize.height - shrinkingSize);
                         picker.frame = CGRectMake(picker.frame.origin.x, picker.frame.origin.y, picker.frame.size.width, picker.frame.size.height/EXPANDING_MULTIPLIER);
                     }completion:^(BOOL finished){
                         
                     }];
}

#pragma mark - Keyboard Methods

- (void)keyboardWasShown:(NSNotification *)notification
{
    if (self.notesEditing) {
        CGRect rawKeyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        UIEdgeInsets contentInset = UIEdgeInsetsMake(0.0, 0.0, rawKeyboardRect.size.height - MAIN_BUTTON_HEIGHT, 0.0);
        self.scrollView.contentInset = contentInset;
        self.scrollView.scrollIndicatorInsets = contentInset;
        CGRect aRect = self.frame;
        aRect.size.height -= rawKeyboardRect.size.height;
        CGPoint point = [self.scrollView convertPoint:self.notesTextView.frame.origin toView:self];
        point.y += self.notesTextView.frame.size.height;
        if (!CGRectContainsPoint(aRect, point) ) {
            CGPoint scrollPoint = CGPointMake(0.0, (self.notesTextView.frame.origin.y + self.notesTextView.frame.size.height - TITLE_LABEL_HEIGHT + DIVIDE_INSET) - rawKeyboardRect.size.height);
            [self.scrollView setContentOffset:scrollPoint animated:YES];
        }
    }
}

- (void) keyboardWillHide:(NSNotification *)notification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

#pragma mark - Gesture Methods

- (void)repeatCellTapped:(UITapGestureRecognizer *)sender
{
    if ([sender.view isEqual:self.repeatCell]) {
        self.changingMainRecurrence = YES;
        [self.eventDelegate recurrenceTappedWithContainsCustom:YES];
    } else {
        [self.eventDelegate recurrenceTappedWithContainsCustom:NO];
    }
}

#pragma mark - Methods

- (void)setRecurrence:(NSString *)recurrence
{
    if (self.changingMainRecurrence) {
        self.repeatCell.textLabel.text = recurrence;
        if (![recurrence isEqualToString:@"Never"]) {
            
            //if (!self.addedRecurrenceViews) [self addEndRecurrenceDateViewsWithCustom:YES];
            
            if ([recurrence isEqualToString:@"Custom"] && !self.addedCustom && !self.addedRecurrenceViews) {
                [self addEndRecurrenceDateViewsWithCustom:YES];
            } else if ([recurrence isEqualToString:@"Custom"] && !self.addedCustom) {
                [self addCustomRecurrenceViews];
            } else if (!self.addedRecurrenceViews) {
                [self addEndRecurrenceDateViewsWithCustom:NO];
            } else if (self.addedCustom) {
                [self removeCustomRecurrenceViews];
            }
            
        } else if (self.addedRecurrenceViews) {
            if (self.addedCustom) [self removeCustomRecurrenceViews];
            [self removeEndRecurrenceDateViews];
        }
        self.changingMainRecurrence = NO;
    } else {
        self.secondRepeatCell.textLabel.text = recurrence;
    }
}

- (void)addCustomRecurrenceViews
{
    self.secondRepeatCell = [self recurrenceCell];
    self.secondRepeatCell.frame = CGRectMake(0.0, self.endRecurrenceDatePicker.frame.origin.y + self.endRecurrenceDatePicker.frame.size.height + DIVIDE_INSET, self.frame.size.width, self.endDateLabel.frame.size.height + 2*DIVIDE_INSET);
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(repeatCellTapped:)];
    [self.secondRepeatCell addGestureRecognizer:tapGesture];
    self.secondRepeatCell.alpha = 0.0;
    [self.scrollView addSubview:self.secondRepeatCell];
    
    self.dayRepeatingView = [[DayRepeatingView alloc] init];
    self.dayRepeatingView.frame = CGRectMake(0.0, self.secondRepeatCell.frame.origin.y + self.secondRepeatCell.frame.size.height + DIVIDE_INSET, self.frame.size.width, BUTTON_SIZE);
    self.dayRepeatingView.alpha = 0.0;
    [self.scrollView addSubview:self.dayRepeatingView];
    
    NSInteger index = [self.views indexOfObject:self.endRecurrenceDatePicker];
    CGFloat heightAddition = self.secondRepeatCell.frame.size.height + self.dayRepeatingView.frame.size.height + 2*DIVIDE_INSET;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.scrollView.contentSize.height + heightAddition);
    [UIView animateWithDuration:0.35
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.secondRepeatCell.alpha = 1.0;
                         self.dayRepeatingView.alpha = 1.0;
                         for (NSInteger i = index + 1; i < [self.views count]; i++) {
                             UIView *view = [self.views objectAtIndex:i];
                             view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y + heightAddition, view.frame.size.width, view.frame.size.height);
                         }
                     }completion:^(BOOL finished){
                         if (finished) {
                             [self.views insertObject:self.secondRepeatCell atIndex:index+1];
                             [self.views insertObject:self.dayRepeatingView atIndex:index+2];
                             self.addedCustom = YES;
                         }
                     }];
}

- (void)removeCustomRecurrenceViews
{
    NSInteger index = [self.views indexOfObject:self.dayRepeatingView];
    CGFloat heightSubtraction = self.secondRepeatCell.frame.size.height + self.dayRepeatingView.frame.size.height + 2*DIVIDE_INSET;
    [UIView animateWithDuration:0.35
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.secondRepeatCell.alpha = 0.0;
                         self.dayRepeatingView.alpha = 0.0;
                         for (NSInteger i = index + 1; i < [self.views count]; i++) {
                             UIView *view = [self.views objectAtIndex:i];
                             view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y - heightSubtraction, view.frame.size.width, view.frame.size.height);
                         }
                     }completion:^(BOOL finished){
                         if (finished) {
                             [self.views removeObject:self.secondRepeatCell];
                             [self.views removeObject:self.dayRepeatingView];
                             [self.secondRepeatCell removeFromSuperview];
                             [self.dayRepeatingView removeFromSuperview];
                             self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.scrollView.contentSize.height - heightSubtraction);
                             self.addedCustom = NO;
                         }
                     }];
}

- (void)addEndRecurrenceDateViewsWithCustom:(BOOL)withCustom
{
    self.endRecurrenceDateLabel = [self labelWithText:@"End on Date:"];
    self.endRecurrenceDateLabel.frame = CGRectMake(DIVIDE_INSET, self.repeatCell.frame.origin.y + self.repeatCell.frame.size.height + DIVIDE_INSET, self.frame.size.width - 2*DIVIDE_INSET, self.endDateLabel.frame.size.height);
    self.endRecurrenceDateLabel.alpha = 0.0;
    [self.scrollView addSubview:self.endRecurrenceDateLabel];
    
    self.endRecurrenceDatePicker = [[DatePickerView alloc] initWithDate:[NSDate date]];
    self.endRecurrenceDatePicker.delegate = self;
    self.endRecurrenceDatePicker.mainColor = [Colors mainGrayColor];
    self.endRecurrenceDatePicker.selectedColor = [Colors secondarGrayColor];
    self.endRecurrenceDatePicker.textColor = [Colors lightestGrayColor];
    self.endRecurrenceDatePicker.frame = CGRectMake(0.0, self.endRecurrenceDateLabel.frame.origin.y + self.endRecurrenceDateLabel.frame.size.height + DIVIDE_INSET, self.frame.size.width, OPTIONS_HEIGHT);
    self.endRecurrenceDatePicker.alpha = 0.0;
    [self.scrollView addSubview:self.endRecurrenceDatePicker];
    
    NSInteger index = [self.views indexOfObject:self.repeatCell];
    CGFloat heightAddition = self.endRecurrenceDateLabel.frame.size.height + self.endRecurrenceDatePicker.frame.size.height + 2*DIVIDE_INSET;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.scrollView.contentSize.height + heightAddition);
    
    [UIView animateWithDuration:0.35
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.endRecurrenceDateLabel.alpha = 1.0;
                         self.endRecurrenceDatePicker.alpha = 1.0;
                         for (NSInteger i = index + 1; i < [self.views count]; i++) {
                             UIView *view = [self.views objectAtIndex:i];
                             view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y + heightAddition, view.frame.size.width, view.frame.size.height);
                         }
                     }completion:^(BOOL finished){
                         if (finished) {
                             self.addedRecurrenceViews = YES;
                             [self.views insertObject:self.endRecurrenceDateLabel atIndex:index + 1];
                             [self.views insertObject:self.endRecurrenceDatePicker atIndex:index + 2];
                             if (withCustom) {
                                 [self addCustomRecurrenceViews];
                             }
                         }
                     }];
}

- (void)removeEndRecurrenceDateViews
{
    NSInteger index = [self.views indexOfObject:self.endRecurrenceDatePicker];
    CGFloat heightSubtraction = self.endRecurrenceDateLabel.frame.size.height + self.endRecurrenceDatePicker.frame.size.height + 2*DIVIDE_INSET;
    [UIView animateWithDuration:0.35
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.endRecurrenceDateLabel.alpha = 0.0;
                         self.endRecurrenceDatePicker.alpha = 0.0;
                         for (NSInteger i = index + 1; i < [self.views count]; i++) {
                             UIView *view = [self.views objectAtIndex:i];
                             view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y - heightSubtraction, view.frame.size.width, view.frame.size.height);
                         }
                     }completion:^(BOOL finished){
                         if (finished) {
                             [self.views removeObject:self.endRecurrenceDateLabel];
                             [self.views removeObject:self.endRecurrenceDatePicker];
                             [self.endRecurrenceDateLabel removeFromSuperview];
                             [self.endRecurrenceDatePicker removeFromSuperview];
                             self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.scrollView.contentSize.height - heightSubtraction);
                             self.addedRecurrenceViews = NO;
                         }
                     }];
}

#pragma mark - Creation Checking Methods

- (BOOL)preparedForSave
{
    if ([self.titleTextView.text isEqualToString:@""]) {
        [self alert:@"Events must have a title."];
        return NO;
    } else if (self.calendarCell.calendar == nil) {
        [self alert:@"Events must have a calendar."];
        return NO;
    } else if (![self datesAndTimesAreValid]) {
        [self alert:@"Specified dates are invalid. Make sure the starting date comes before the end date."];
        return NO;
    }
    return YES;
}
               
- (BOOL)datesAndTimesAreValid
{
    NSDate *startDate = [CalInfo dateWithMonth:[NSString stringWithFormat:@"%li", (long)self.startDate.monthNum] andDay:[self.startDate.options objectAtIndex:1] andYear:[self.startDate.options objectAtIndex:2] andTime:[NSString stringWithFormat:@"%@:%@ %@", [self.startTime.options objectAtIndex:0], [self.startTime.options objectAtIndex:1], [self.startTime.options objectAtIndex:2]]];
    NSDate *endDate = [CalInfo dateWithMonth:[NSString stringWithFormat:@"%li", (long)self.endDate.monthNum] andDay:[self.endDate.options objectAtIndex:1] andYear:[self.endDate.options objectAtIndex:2] andTime:[NSString stringWithFormat:@"%@:%@ %@", [self.endTime.options objectAtIndex:0], [self.endTime.options objectAtIndex:1], [self.endTime.options objectAtIndex:2]]];
    
    if (endDate <= startDate) return NO;
    return YES;
}

#pragma mark - Alert View Methods

- (void)alert:(NSString *)msg
{
    [[[UIAlertView alloc] initWithTitle:@"Create New Event"
                                message:msg
                               delegate:nil
                      cancelButtonTitle:nil
                      otherButtonTitles:@"OK", nil] show];
}

@end
