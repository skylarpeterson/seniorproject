//
//  NewToDoView.m
//  SeniorProject
//
//  Created by Skylar Peterson on 2/10/14.
//  Copyright (c) 2014 SkylarPeterson. All rights reserved.
//

#import "NewTaskView.h"
#import "Colors.h"
#import "Fonts.h"
#import "CalInfo.h"
#import "Methods.h"
#import "OptionsView.h"
#import "DatePickerView.h"

@interface NewTaskView() <UITextViewDelegate, OptionsViewDelegate, PickerDelegate>

@property (nonatomic, strong) NSMutableArray *views;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *calendarLabel;
@property (nonatomic, strong) OptionsView *isMultiOptionsView;
@property (nonatomic, strong) UILabel *dateToAddLabel;
@property (nonatomic, strong) DatePickerView *dateToAddPicker;
@property (nonatomic, strong) UILabel *dueDateLabel;
@property (nonatomic, strong) DatePickerView *dateDuePicker;

@property (nonatomic) CGSize currentTextSize;

@end

@implementation NewTaskView

#pragma mark - Information

- (NSString *)contents
{
    return self.textView.text;
}

- (NSInteger)calendar
{
    return 0;
}

- (BOOL)isMulti
{
    if (self.isMultiOptionsView.selectedIndex == 0) {
        return NO;
    } else {
        return YES;
    }
}

- (NSDate *)dateToSee
{
    NSString *monthString = [NSString stringWithFormat:@"%li", (long)self.dateToAddPicker.monthNum];
    return [CalInfo dateWithMonth:monthString andDay:[self.dateToAddPicker.options objectAtIndex:1] andYear:[self.dateToAddPicker.options objectAtIndex:2]];
}

- (NSDate *)dateDue
{
    NSString *monthString = [NSString stringWithFormat:@"%li", (long)self.dateDuePicker.monthNum];
    return [CalInfo dateWithMonth:monthString andDay:[self.dateDuePicker.options objectAtIndex:1] andYear:[self.dateDuePicker.options objectAtIndex:2]];
}

#pragma mark - Views and Initialization

- (NSMutableArray *)views
{
    if (!_views) _views = [[NSMutableArray alloc] init];
    return _views;
}

- (void)initialize
{
    self.backgroundColor = [Colors lightestGrayColor];
    self.titleText = @"Add New Task";
    self.textColor = [Colors mainGrayColor];
    
    self.textLabel = [self labelWithText:@"Text:"];
    
    self.textView = [[UITextView alloc] init];
    self.textView.delegate = self;
    self.textView.scrollEnabled = NO;
    self.textView.layer.cornerRadius = 5.0;
    self.textView.textColor = [Colors secondarGrayColor];
    self.textView.font = self.textLabel.font;
    self.textView.backgroundColor = [Colors secondaryLightestGrayColor];
    self.textView.returnKeyType = UIReturnKeyDone;
    [self.textView setTextContainerInset:UIEdgeInsetsMake(1.0, 1.0, 1.0, 1.0)];
    
    self.calendarLabel = [self labelWithText:@"Calendar:"];
    self.calendarCell.backgroundColor = [Colors secondaryLightestGrayColor];
    
    self.isMultiOptionsView = [[OptionsView alloc] init];
    self.isMultiOptionsView.delegate = self;
    self.isMultiOptionsView.options = @[@"Single Item", @"Multiple Items"];
    self.isMultiOptionsView.textColor = [Colors mainGrayColor];
    self.isMultiOptionsView.unselectedColor = [Colors lightestGrayColor];
    self.isMultiOptionsView.backgroundColor = [Colors secondaryLightestGrayColor];
    self.isMultiOptionsView.selectedIndex = 0;
    
    self.dateToAddLabel = [self labelWithText:@"I want to see this task on:"];
    self.dateToAddPicker = [[DatePickerView alloc] initWithDate:[NSDate date]];
    self.dateToAddPicker.delegate = self;
    self.dateToAddPicker.mainColor = [Colors lightestGrayColor];
    self.dateToAddPicker.selectedColor = [Colors secondaryLightestGrayColor];
    self.dateToAddPicker.textColor = [Colors mainGrayColor];
    
    self.dueDateLabel = [self labelWithText:@"This task is due on:"];
    self.dateDuePicker = [[DatePickerView alloc] initWithDate:[NSDate date]];
    self.dateDuePicker.delegate = self;
    self.dateDuePicker.mainColor = [Colors lightestGrayColor];
    self.dateDuePicker.selectedColor = [Colors secondaryLightestGrayColor];
    self.dateDuePicker.textColor = [Colors mainGrayColor];
    
    [self.scrollView addSubview:self.textLabel];
    [self.views addObject:self.textLabel];
    [self.scrollView addSubview:self.textView];
    [self.views addObject:self.textView];
    [self.scrollView addSubview:self.calendarLabel];
    [self.views addObject:self.calendarLabel];
    [self.views addObject:self.calendarCell];
    [self.scrollView addSubview:self.isMultiOptionsView];
    [self.views addObject:self.isMultiOptionsView];
    [self.scrollView addSubview:self.dateToAddLabel];
    [self.views addObject:self.dateToAddLabel];
    [self.scrollView addSubview:self.dateToAddPicker];
    [self.views addObject:self.dateToAddPicker];
    [self.scrollView addSubview:self.dueDateLabel];
    [self.views addObject:self.dueDateLabel];
    [self.scrollView addSubview:self.dateDuePicker];
    [self.views addObject:self.dateDuePicker];
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(DIVIDE_INSET, 0.0, self.frame.size.width - 2*DIVIDE_INSET, [Methods sizeForText:self.textLabel.text withWidth:self.frame.size.width - 2 * DIVIDE_INSET andFont:self.textLabel.font].height);
    self.textView.frame = CGRectMake(DIVIDE_INSET, self.textLabel.frame.origin.y + self.textLabel.frame.size.height + DIVIDE_INSET, self.frame.size.width - 2 * DIVIDE_INSET, self.textLabel.frame.size.height + DIVIDE_INSET/2.0);
    self.currentTextSize = [Methods sizeForText:@"text" withWidth:self.textView.frame.size.width andFont:self.textView.font];
    self.calendarLabel.frame = CGRectMake(DIVIDE_INSET, self.textView.frame.origin.y + self.textView.frame.size.height + DIVIDE_INSET, self.frame.size.width - 2*DIVIDE_INSET, [Methods sizeForText:self.calendarLabel.text withWidth:self.frame.size.width - 2*DIVIDE_INSET andFont:self.calendarLabel.font].height);
    self.calendarCell.frame = CGRectMake(0.0, self.calendarLabel.frame.origin.y + self.calendarLabel.frame.size.height + DIVIDE_INSET, self.frame.size.width, self.calendarLabel.frame.size.height + 2*DIVIDE_INSET);
    self.isMultiOptionsView.frame = CGRectMake(0.0, self.calendarCell.frame.origin.y + self.calendarCell.frame.size.height + DIVIDE_INSET, self.frame.size.width, 50.0);
    self.dateToAddLabel.frame = CGRectMake(DIVIDE_INSET, self.isMultiOptionsView.frame.origin.y + self.isMultiOptionsView.frame.size.height + DIVIDE_INSET, self.frame.size.width - 2 *DIVIDE_INSET, [Methods sizeForText:self.dateToAddLabel.text withWidth:self.frame.size.width - 2*DIVIDE_INSET andFont:self.dateToAddLabel.font].height);
    self.dateToAddPicker.frame = CGRectMake(0.0, self.dateToAddLabel.frame.origin.y + self.dateToAddLabel.frame.size.height + DIVIDE_INSET, self.frame.size.width, 50.0);
    self.dueDateLabel.frame = CGRectMake(DIVIDE_INSET, self.dateToAddPicker.frame.origin.y + self.dateToAddPicker.frame.size.height + DIVIDE_INSET, self.frame.size.width - 2*DIVIDE_INSET, [Methods sizeForText:self.dueDateLabel.text withWidth:self.frame.size.width - 2*DIVIDE_INSET andFont:self.dueDateLabel.font].height);
    self.dateDuePicker.frame = CGRectMake(0.0, self.dueDateLabel.frame.origin.y + self.dueDateLabel.frame.size.height + DIVIDE_INSET, self.frame.size.width, 50.0);
    
    CGFloat contentSize = 0.0;
    for (UIView *view in self.views) {
        contentSize += view.frame.size.height + DIVIDE_INSET;
    }
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width, contentSize);
}

- (void)selectedIndexChangedToIndex:(NSInteger)index {}

#pragma mark - UITextView Delegate Methods

- (void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) return;
    CGSize newSize = [Methods sizeForText:self.textView.text withWidth:self.textView.frame.size.width andFont:self.textView.font];
    if (newSize.height > self.currentTextSize.height || newSize.height < self.currentTextSize.height) {\
        CGFloat change = newSize.height - self.textView.frame.size.height + INSET/2.0;
        NSInteger index = [self.views indexOfObject:self.textView];
        [UIView animateWithDuration:0.25
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                            self.textView.frame = CGRectMake(self.textView.frame.origin.x, self.textView.frame.origin.y, self.textView.frame.size.width, newSize.height + INSET/2.0);
                             for (NSInteger i = index + 1; i < [self.views count]; i++) {
                                 UIView *view = [self.views objectAtIndex:i];
                                 view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y + change, view.frame.size.width, view.frame.size.height);
                             }
                             self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.scrollView.contentSize.height + change);
                         }completion:^(BOOL finished){
                             if (finished) {
                                 self.currentTextSize = newSize;
                             }
                         }];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    return YES;
}

#pragma mark - Date Picker Delegate Methods

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
                             DatePickerView *pickerView = (DatePickerView *)picker;
                            [pickerView finishedExpanding];
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

- (BOOL)preparedForSave
{
    if ([self.textView.text isEqualToString:@""]) {
        [self alert:@"New tasks cannot have blank descriptions."];
        return NO;
    }
    if (![self datesAreValid]) {
        [self alert:@"The due date for the new task comes before the date it should appear in your active tasks. Due dates must either be the same or past the date you want to see the task."];
        return NO;
    }
    return YES;
}

- (BOOL)datesAreValid
{
    NSString *year1 = [self.dateToAddPicker.options objectAtIndex:2];
    NSString *year2 = [self.dateDuePicker.options objectAtIndex:2];
    if (year2.intValue < year1.intValue) return NO;
    else {
        if (self.dateDuePicker.monthNum < self.dateToAddPicker.monthNum) return NO;
        else {
            NSString *day1 = [self.dateToAddPicker.options objectAtIndex:1];
            NSString *day2 = [self.dateDuePicker.options objectAtIndex:1];
            if (day2.intValue < day1.intValue) return NO;
        }
    }
    
    return YES;
}

#pragma mark - Alert View Methods

- (void)alert:(NSString *)msg
{
    [[[UIAlertView alloc] initWithTitle:@"Create New List"
                                message:msg
                               delegate:nil
                      cancelButtonTitle:nil
                      otherButtonTitles:@"OK", nil] show];
}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 1) {
//        self.deleteItem = YES;
//        [self performSegueWithIdentifier:DELETE_LIST_IDENTIFIER sender:self];
//    } else {
//        self.deleteItem = NO;
//    }
//}

@end
