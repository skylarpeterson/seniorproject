//
//  ToDoCalViewController.m
//  SeniorProject
//
//  Created by Skylar Peterson on 1/20/14.
//  Copyright (c) 2014 SkylarPeterson. All rights reserved.
//

#import "ToDoCalViewController.h"
#import <EventKit/EventKit.h>
#import "Availabilities.h"
#import "CalendarCell.h"

#import "DayView.h"
#import "CalEventView.h"
#import "DaySelectionView.h"
#import "NewEventView.h"

#import "Fonts.h"
#import "Colors.h"
#import "CalInfo.h"

@interface ToDoCalViewController () <DaySelectionViewDelegate, AddViewDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (nonatomic) BOOL yearIsShowing;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet DayView *dayView;
@property (weak, nonatomic) IBOutlet DaySelectionView *daySelectionView;

@property (nonatomic, strong) UIView *blockerView;
@property (nonatomic, strong) NewEventView *addEventView;

@property (nonatomic) CGPoint originalDaySelectionViewCenter;
@property (nonatomic, strong) DaySelectionView *leftSwitchWeekView;
@property (nonatomic, strong) DaySelectionView *rightSwitchWeekView;
@property (nonatomic) CGPoint originalLeftCenter;
@property (nonatomic) CGPoint originalRightCenter;

@property (nonatomic) BOOL listShowing;

@end

#define CELL_IDENTIFIER @"CalendarCell"

@implementation ToDoCalViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dateLabel.text = [NSString stringWithFormat:@"%@ %li", [CalInfo monthShorteningForDate:self.date], [CalInfo dateForNSDate:self.date]];
    self.dateLabel.textColor = [Colors mainGrayColor];
    self.dateLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dateLabelTapped)];
    [self.dateLabel addGestureRecognizer:tapGesture];
    self.yearIsShowing = NO;
    
    self.dateLabel.font = [Fonts titleFont];
    //[self.addButton setBackgroundImage:[[UIImage imageNamed:@"AddIcon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    self.daySelectionView.delegate = self;
    self.daySelectionView.dates = [CalInfo weekDayNumsForWeekWithDate:self.date];
    self.daySelectionView.selectedIndex = [CalInfo dayNumForDate:self.date];
    [self.view bringSubviewToFront:self.daySelectionView];
    
    self.dayView.events = self.events;
    
//    CalEventView *event = [[CalEventView alloc] initWithEvent:[self.events objectAtIndex:0]];
//    event.frame = CGRectMake(40.0, 0.0, self.dayView.scrollView.frame.size.width - 40.0, 120.0);
//    [self.dayView.scrollView addSubview:event];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    if (self.listShowing) {
        return UIStatusBarStyleLightContent;
    } else {
        return UIStatusBarStyleDefault;
    }
}

#pragma mark - Day Selection View Delegate Methods

#define LABEL_WIDTH 150.0
- (void)daySelectionViewPanningBegan
{
    self.originalDaySelectionViewCenter = self.daySelectionView.center;
    
    self.leftSwitchWeekView = [[DaySelectionView alloc] initWithFrame:CGRectMake(-self.daySelectionView.frame.size.width, self.daySelectionView.frame.origin.y, self.daySelectionView.frame.size.width, self.daySelectionView.frame.size.height)];
    self.leftSwitchWeekView.dates = @[[NSNumber numberWithInt:25],
                                      [NSNumber numberWithInt:26],
                                      [NSNumber numberWithInt:27],
                                      [NSNumber numberWithInt:28],
                                      [NSNumber numberWithInt:29],
                                      [NSNumber numberWithInt:30],
                                      [NSNumber numberWithInt:31]];
    [self.view addSubview:self.leftSwitchWeekView];
    self.originalLeftCenter = self.leftSwitchWeekView.center;
    
    self.rightSwitchWeekView = [[DaySelectionView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, self.daySelectionView.frame.origin.y, self.daySelectionView.frame.size.width, self.daySelectionView.frame.size.height)];
    self.rightSwitchWeekView.dates = @[[NSNumber numberWithInt:8],
                                      [NSNumber numberWithInt:9],
                                      [NSNumber numberWithInt:10],
                                      [NSNumber numberWithInt:11],
                                      [NSNumber numberWithInt:12],
                                      [NSNumber numberWithInt:13],
                                      [NSNumber numberWithInt:14]];
    [self.view addSubview:self.rightSwitchWeekView];
    self.originalRightCenter = self.rightSwitchWeekView.center;
    
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.leftSwitchWeekView.frame.size.width - LABEL_WIDTH, 0.0, LABEL_WIDTH, self.leftSwitchWeekView.frame.size.height)];
    leftLabel.text = @"Dec. 25-31";
    leftLabel.textAlignment = NSTextAlignmentCenter;
    leftLabel.textColor = [UIColor whiteColor];
    leftLabel.font = [Fonts weekSwitchFont];
    leftLabel.backgroundColor = [Colors secondarGrayColorFaded];
    [self.leftSwitchWeekView addSubview:leftLabel];
    
    UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, LABEL_WIDTH, self.rightSwitchWeekView.frame.size.height)];
    rightLabel.text = @"Jan. 8-14";
    rightLabel.textAlignment = NSTextAlignmentCenter;
    rightLabel.textColor = [UIColor whiteColor];
    rightLabel.font = [Fonts weekSwitchFont];
    rightLabel.backgroundColor = [Colors secondarGrayColorFaded];
    [self.rightSwitchWeekView addSubview:rightLabel];
}

- (void)daySelectionViewPanningChanged:(CGPoint)translation
{
    if (translation.x <= -LABEL_WIDTH || translation.x >= LABEL_WIDTH) {
        return;
    }
    self.daySelectionView.center = CGPointMake(self.originalDaySelectionViewCenter.x + translation.x, self.originalDaySelectionViewCenter.y);
    self.leftSwitchWeekView.center = CGPointMake(self.originalLeftCenter.x + translation.x, self.originalLeftCenter.y);
    self.rightSwitchWeekView.center = CGPointMake(self.originalRightCenter.x + translation.x, self.originalRightCenter.y);
}

- (void)daySelectionViewPanningEnded
{
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.daySelectionView.center = self.originalDaySelectionViewCenter;
                         self.leftSwitchWeekView.center = self.originalLeftCenter;
                         self.rightSwitchWeekView.center = self.originalRightCenter;
                     }completion:^(BOOL finished){
                         [self.leftSwitchWeekView removeFromSuperview];
                         [self.rightSwitchWeekView removeFromSuperview];
                     }];
}

- (IBAction)changeView:(id)sender
{
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.view.backgroundColor = [Colors mainGrayColor];
                     }
                     completion:^(BOOL finished){
                         if (finished) {
                             self.listShowing = YES;
                             [self setNeedsStatusBarAppearanceUpdate];
                         }
                     }];
}

- (IBAction)unwindList:(UIStoryboardSegue *)sender {}

#pragma mark - Button Methods

#define ADD_VIEW_INSET 10.0
- (IBAction)addEvent:(id)sender
{
    self.blockerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
    self.blockerView.alpha = 0.0;
    self.blockerView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
    [self.view addSubview:self.blockerView];
    
    self.addEventView = [[NewEventView alloc] initWithFrame:CGRectMake(ADD_VIEW_INSET, self.view.frame.size.height, self.view.frame.size.width - 2 * ADD_VIEW_INSET, self.view.frame.size.height/1.35)];
    self.addEventView.delegate = self;
    [self.view addSubview:self.addEventView];
    [UIView animateWithDuration:0.35
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.blockerView.alpha = 1.0;
                         self.addEventView.frame = CGRectMake(self.addEventView.frame.origin.x, self.view.frame.size.height/2.0 - self.addEventView.frame.size.height/2.0, self.addEventView.frame.size.width, self.addEventView.frame.size.height);
                     }completion:nil];
}

#pragma mark - Add View Delegate Methods

- (void)cancelTapped
{
    [UIView animateWithDuration:0.35
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.blockerView.alpha = 0.0;
                         self.addEventView.frame = CGRectMake(self.addEventView.frame.origin.x, self.view.frame.size.height, self.addEventView.frame.size.width, self.addEventView.frame.size.height);
                     }completion:^(BOOL finished){
                         if (finished) {
                             [self.blockerView removeFromSuperview];
                             [self.addEventView removeFromSuperview];
                         }
                     }];
}

- (void)createTapped
{
    
}

#pragma mark - Gesture Recognizer Methods

- (void)dateLabelTapped
{
    if (self.yearIsShowing) {
        self.dateLabel.text = [NSString stringWithFormat:@"%@ %li", [CalInfo monthShorteningForDate:self.date], [CalInfo dateForNSDate:self.date]];
        self.yearIsShowing = NO;
    } else {
        self.dateLabel.text = [CalInfo yearForDate:self.date];
        self.yearIsShowing = YES;
    }
}

@end
