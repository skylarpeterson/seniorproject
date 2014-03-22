//
//  TestViewController.m
//  SeniorProject
//
//  Created by Skylar Peterson on 2/9/14.
//  Copyright (c) 2014 SkylarPeterson. All rights reserved.
//

#import "TestViewController.h"
#import <EventKit/EventKit.h>
#import "ListCell.h"
#import "Colors.h"
#import "DatePickerView.h"

@interface TestViewController () <PickerDelegate>

@property (nonatomic, strong) NSArray *listItems;
@property (weak, nonatomic) IBOutlet DatePickerView *datePicker;

@end

@implementation TestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [Colors secondarGrayColor];
    self.datePicker.delegate = self;
}

- (void)pickerExpanding:(UIView *)picker
{
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.datePicker.frame = CGRectMake(self.datePicker.frame.origin.x, self.datePicker.frame.origin.y, self.datePicker.frame.size.width, 4 * self.datePicker.frame.size.height);
                     }completion:^(BOOL finished){
                         if (finished) {
                             [self.datePicker finishedExpanding];
                         }
                     }];
}

- (void)pickerShrinking:(UIView *)picker
{
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.datePicker.frame = CGRectMake(self.datePicker.frame.origin.x, self.datePicker.frame.origin.y, self.datePicker.frame.size.width, self.datePicker.frame.size.height/4.0);
                     }completion:nil];
}

@end
