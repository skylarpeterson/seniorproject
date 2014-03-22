//
//  SummaryViewController.m
//  One
//
//  Created by Skylar Peterson on 2/24/14.
//  Copyright (c) 2014 SkylarPeterson. All rights reserved.
//

#import "Availabilities.h"
#import <CoreData/CoreData.h>

#import "SummaryViewController.h"
#import "ListViewController.h"
#import "PageContentViewController.h"
#import "ToDoCalViewController.h"
#import "AddItemViewController.h"
#import "SettingsViewController.h"

#import "CalendarCell.h"
#import "NextEventView.h"
#import "NewEventView.h"
#import "NoEventsView.h"
#import "TaskSummaryView.h"
#import "DatePickerView.h"

#import "Fonts.h"
#import "Colors.h"
#import "CalInfo.h"
#import "Methods.h"

@interface SummaryViewController () <UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning, UIPageViewControllerDataSource, UITableViewDataSource, UITableViewDelegate, NoEventsDelegate, PickerDelegate>

@property (nonatomic, strong) NSDate *date;

@property (nonatomic, strong) NSMutableArray *views;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet TaskSummaryView *taskSummaryView;
@property (nonatomic, strong) CALayer *horizontalBreak;
@property (nonatomic, strong) CALayer *verticalBreak;

@property (nonatomic, strong) NoEventsView *noEventsView;
@property (nonatomic) NSInteger numTasksLeft;
@property (nonatomic) NSInteger numTasksComplete;

@property (nonatomic) BOOL presentingList;
@property (nonatomic) BOOL presentedList;
@property (nonatomic) BOOL presentingAdd;
@property (nonatomic) BOOL presentedAdd;
@property (nonatomic) BOOL presentingSettings;
@property (nonatomic) BOOL presentedSettings;

@property (nonatomic, strong) DatePickerView *datePicker;
@property (nonatomic) BOOL pickingDate;

@end

@implementation SummaryViewController

- (NSMutableArray *)views
{
    if (!_views) _views = [[NSMutableArray alloc] init];
    return _views;
}

- (NSDate *)date
{
    if (!_date) _date = [NSDate date];
    return _date;
}

- (void)setDocument:(UIManagedDocument *)document
{
    _document = document;
    [self makeTasksRequest];
}

- (void)setStore:(EKEventStore *)store
{
    _store = store;
    [self makeRequest];
}

- (void)makeRequest
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSArray *dateComponents = [CalInfo dateComponentsForDate:self.date];
    NSDateComponents *todayComponents = [[NSDateComponents alloc] init];
    [todayComponents setMonth:((NSString *)[dateComponents objectAtIndex:0]).integerValue];
    [todayComponents setDay:((NSString *) [dateComponents objectAtIndex:1]).integerValue];
    [todayComponents setYear:((NSString *) [dateComponents objectAtIndex:2]).integerValue];
    NSDate *todayDate = [calendar dateFromComponents:todayComponents];
    
    NSDateComponents *oneDayAgoComponents = [[NSDateComponents alloc] init];
    oneDayAgoComponents.day = 0;
    NSDate *oneDayAgo = [calendar dateByAddingComponents:oneDayAgoComponents
                                                  toDate:todayDate
                                                 options:0];
    
    NSDateComponents *oneDayFromNowComponents = [[NSDateComponents alloc] init];
    oneDayFromNowComponents.day = 1;
    NSDate *oneDayFromNow = [calendar dateByAddingComponents:oneDayFromNowComponents
                                                      toDate:todayDate
                                                     options:0];
    
    NSPredicate *predicate = [self.store predicateForEventsWithStartDate:oneDayAgo
                                                                 endDate:oneDayFromNow
                                                               calendars:nil];
    
    NSArray *events = [self.store eventsMatchingPredicate:predicate];
    NSMutableArray *mutableEvents = [events mutableCopy];
    for (int i = 0; i < [events count]; i++) {
        EKEvent *event = [events objectAtIndex:i];
        if (event.allDay || event.calendar.type == EKCalendarTypeBirthday) {
            [mutableEvents removeObject:event];
        }
    }
    self.events = [mutableEvents copy];
    [self performSelectorOnMainThread:@selector(updateNextEvent) withObject:self waitUntilDone:NO];
}

- (void)makeTasksRequest
{
    NSManagedObjectContext *moc = [self.document managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"ListItem" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSArray *dateComponents = [CalInfo dateComponentsForDate:self.date];
    NSDateComponents *todayComponents = [[NSDateComponents alloc] init];
    [todayComponents setMonth:((NSString *)[dateComponents objectAtIndex:0]).integerValue];
    [todayComponents setDay:((NSString *) [dateComponents objectAtIndex:1]).integerValue];
    [todayComponents setYear:((NSString *) [dateComponents objectAtIndex:2]).integerValue];
    NSDate *todayDate = [calendar dateFromComponents:todayComponents];
    
    NSDateComponents *oneDayAgoComponents = [[NSDateComponents alloc] init];
    oneDayAgoComponents.day = 0;
    NSDate *dayStart = [calendar dateByAddingComponents:oneDayAgoComponents
                                                  toDate:todayDate
                                                 options:0];
    
    NSDateComponents *oneDayFromNowComponents = [[NSDateComponents alloc] init];
    oneDayFromNowComponents.day = 1;
    NSDate *dayEnd = [calendar dateByAddingComponents:oneDayFromNowComponents
                                                      toDate:todayDate
                                                     options:0];
    
    request.predicate = [NSPredicate predicateWithFormat:@"(dateDue >= %@) AND (dateDue <= %@) AND (completed == NO)", dayStart, dayEnd];
    [request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"dateDue" ascending:YES]]];
    
    NSError *error;
    self.numTasksLeft = [[moc executeFetchRequest:request error:&error] count];
    
    request.predicate = [NSPredicate predicateWithFormat:@"(dateDue == %@) AND (completed == YES)", self.date];
    [request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"dateDue" ascending:YES]]];
    
    self.numTasksComplete = [[moc executeFetchRequest:request error:&error] count];
    [self performSelectorOnMainThread:@selector(updateTaskSummaries) withObject:nil waitUntilDone:NO];
}

- (void)updateTaskSummaries
{
    self.taskSummaryView.numLeft = self.numTasksLeft;
    self.taskSummaryView.numCompleted = self.numTasksComplete;
}

- (void)prepareForNewRequest
{
    [self.pageViewController.view removeFromSuperview];
    if (self.noEventsView) [self.noEventsView removeFromSuperview];
    [self.views removeObject:self.pageViewController.view];
}

#define MINI_CELL_IDENTIFIER @"MiniCell"
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.dateLabel.text = [NSString stringWithFormat:@"%@ %li", [CalInfo monthShorteningForDate:self.date], [CalInfo dateForNSDate:self.date]];
    self.dateLabel.textColor = [Colors mainGrayColor];
    self.dateLabel.font = [Fonts titleFont];
    self.dateLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDatePicker)];
    [self.dateLabel addGestureRecognizer:tapGesture];
    
    [self.tableView registerClass:[CalendarCell class] forCellReuseIdentifier:MINI_CELL_IDENTIFIER];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorColor = [Colors mainGrayColor];
    self.tableView.allowsSelection = NO;
    
    self.taskSummaryView.numLeft = self.numTasksLeft;
    self.taskSummaryView.numCompleted = self.numTasksComplete;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(becomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    [self.views addObject:self.tableView];
    [self.views addObject:self.taskSummaryView];
}

- (void)becomeActive:(NSNotification *)notification
{
    [self.pageViewController.view removeFromSuperview];
    [self makeRequest];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    if (self.presentingList) {
        return UIStatusBarStyleLightContent;
    } else {
        return UIStatusBarStyleDefault;
    }
}

- (void)updateNextEvent
{
    if ([self.events count] > 0) {
        self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
        self.pageViewController.dataSource = self;
        
        PageContentViewController *startingViewController = [self viewControllerAtIndex:[self indexOfNextEvent]];
        NSArray *viewControllers = @[startingViewController];
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        
        self.pageViewController.view.frame = CGRectMake(0.0, 83.0, self.view.frame.size.width, 319.0);
        [self.views addObject:self.pageViewController.view];
        [self addChildViewController:self.pageViewController];
        [self.view addSubview:self.pageViewController.view];
        [self.pageViewController didMoveToParentViewController:self];
        
        UIPageControl *pageControl = [UIPageControl appearance];
        pageControl.pageIndicatorTintColor = [Colors lightestGrayColor];
        pageControl.currentPageIndicatorTintColor = [Colors mainGrayColor];
        pageControl.backgroundColor = [UIColor whiteColor];
        
        self.horizontalBreak = [CALayer layer];
        self.horizontalBreak.backgroundColor = [[Colors secondarGrayColor] CGColor];
        self.horizontalBreak.frame = CGRectMake(0.0, self.pageViewController.view.frame.origin.y + self.pageViewController.view.frame.size.height + 5.0, self.view.frame.size.width, 0.5);
        [self.view.layer addSublayer:self.horizontalBreak];
        [self.views addObject:self.horizontalBreak];
        
        self.verticalBreak = [CALayer layer];
        self.verticalBreak.backgroundColor = [[Colors secondarGrayColor] CGColor];
        self.verticalBreak.frame = CGRectMake(self.view.frame.size.width / 2.0, self.horizontalBreak.frame.origin.y, 0.5, self.view.frame.size.width / 2.0);
        [self.view.layer addSublayer:self.verticalBreak];
        [self.views addObject:self.verticalBreak];
        
        [self.tableView reloadData];
        if (!self.tableView.superview) [self.view addSubview:self.tableView];
        if (!self.taskSummaryView.superview) [self.view addSubview:self.taskSummaryView];
    } else {
        [self.tableView removeFromSuperview];
        //[self.views removeObject:self.tableView];
        [self.taskSummaryView removeFromSuperview];
        //[self.views removeObject:self.taskSummaryView];
        [self.horizontalBreak removeFromSuperlayer];
        [self.views removeObject:self.horizontalBreak];
        [self.verticalBreak removeFromSuperlayer];
        [self.views removeObject:self.verticalBreak];
        self.noEventsView = [[NoEventsView alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.height/2.0 - IMAGE_VIEW_SIZE, self.view.frame.size.width, 2*IMAGE_VIEW_SIZE)];
        self.noEventsView.delegate = self;
        [self.view addSubview:self.noEventsView];
        [self.views addObject:self.noEventsView];
    }
    
}

#pragma mark - Gesture Methods

#define OPTIONS_HEIGHT 50.0
- (void)showDatePicker
{
    if (!self.pickingDate) {
        self.datePicker = [[DatePickerView alloc] initWithDate:self.date];
        self.datePicker.delegate = self;
        self.datePicker.mainColor = [UIColor whiteColor];
        self.datePicker.selectedColor = [Colors lightestGrayColor];
        self.datePicker.textColor = [Colors mainGrayColor];
        self.datePicker.alpha = 0.0;
        self.datePicker.frame = CGRectMake(0.0, self.dateLabel.frame.origin.y + self.dateLabel.frame.size.height, self.view.frame.size.width, OPTIONS_HEIGHT);
        [self.view addSubview:self.datePicker];
        [UIView animateWithDuration:0.35
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.datePicker.alpha = 1.0;
                             for (NSInteger i = 0; i < [self.views count]; i++) {
                                 UIView *view = [self.views objectAtIndex:i];
                                 view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y + OPTIONS_HEIGHT, view.frame.size.width, view.frame.size.height);
                             }
                         }completion:^(BOOL finished){
                             if (finished) {
                                 self.pickingDate = YES;
                             }
                         }];
    } else {
        [UIView animateWithDuration:0.35
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.datePicker.alpha = 0.0;
                             for (NSInteger i = 0; i < [self.views count]; i++) {
                                 UIView *view = [self.views objectAtIndex:i];
                                 view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y - self.datePicker.frame.size.height, view.frame.size.width, view.frame.size.height);
                             }
                         }completion:^(BOOL finished){
                             if (finished) {
                                 self.date = [CalInfo dateWithMonth:[self.datePicker.options objectAtIndex:0]
                                                             andDay:[self.datePicker.options objectAtIndex:1]
                                                            andYear:[self.datePicker.options objectAtIndex:2]];
                                 self.dateLabel.text = [NSString stringWithFormat:@"%@ %li", [CalInfo monthShorteningForDate:self.date], [CalInfo dateForNSDate:self.date]];
                                 [self prepareForNewRequest];
                                 [self.datePicker removeFromSuperview];
                                 self.pickingDate = NO;
                                 [self makeRequest];
                             }
                         }];
    }
}

#pragma mark - Picker Delegate Methods

#define EXPANDING_MULTIPLIER 5.0
- (void)pickerExpanding:(UIView *)picker
{
    CGFloat expandingSize = EXPANDING_MULTIPLIER * picker.frame.size.height - picker.frame.size.height;
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         for (NSInteger i = 0; i < [self.views count]; i++) {
                             UIView *view = [self.views objectAtIndex:i];
                             view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y + expandingSize, view.frame.size.width, view.frame.size.height);
                         }
                         picker.frame = CGRectMake(picker.frame.origin.x, picker.frame.origin.y, picker.frame.size.width, EXPANDING_MULTIPLIER * picker.frame.size.height);
                     }completion:^(BOOL finished){
                         if (finished) {
                             [(PickerView *)picker finishedExpanding];
                         }
                     }];
}

- (void)pickerShrinking:(UIView *)picker
{
    CGFloat shrinkingSize = picker.frame.size.height - picker.frame.size.height/EXPANDING_MULTIPLIER;
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         for (NSInteger i = 0; i < [self.views count]; i++) {
                             UIView *view = [self.views objectAtIndex:i];
                             view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y - shrinkingSize, view.frame.size.width, view.frame.size.height);
                         }
                         picker.frame = CGRectMake(picker.frame.origin.x, picker.frame.origin.y, picker.frame.size.width, picker.frame.size.height/EXPANDING_MULTIPLIER);
                     }completion:nil];
}

#pragma mark - Table View Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.events count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [Methods sizeForText:((EKEvent *)[self.events objectAtIndex:indexPath.row]).title withWidth:self.tableView.frame.size.width - 10.0 - 2*INSET andFont:[Fonts miniTableViewMainFont]].height + 20.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarCell *cell = (CalendarCell *)[self.tableView dequeueReusableCellWithIdentifier:MINI_CELL_IDENTIFIER forIndexPath:indexPath];
    
    cell.calendarColor = [UIColor colorWithCGColor:((EKEvent *)[self.events objectAtIndex:indexPath.row]).calendar.CGColor];
    cell.calendarName = ((EKEvent *)[self.events objectAtIndex:indexPath.row]).title;
    cell.font = [Fonts miniTableViewMainFont];
    cell.textColor = [Colors mainGrayColor];
    cell.circleSize = 10.0;
    
    return cell;
}

#pragma mark - Table View Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PageContentViewController *viewController = [self viewControllerAtIndex:indexPath.row];
    NSArray *viewControllers = @[viewController];
    NSInteger currentIndex = ((PageContentViewController *)[[self.pageViewController viewControllers] objectAtIndex:0]).pageIndex;
    if (indexPath.row < currentIndex) {
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    } else if (indexPath.row > currentIndex) {
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    }
}

#pragma mark - Segue Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    if ([segue.identifier isEqualToString:@"ShowList"]) {
        if ([segue.destinationViewController isKindOfClass:[ListViewController class]]) {
            ListViewController *listController = (ListViewController *)segue.destinationViewController;
            listController.date = self.date;
            listController.document = self.document;
            listController.calendars = [self.store calendarsForEntityType:EKEntityTypeEvent];
            listController.transitioningDelegate = self;
            listController.modalPresentationStyle = UIModalPresentationCustom;
        }
    } else if ([segue.identifier isEqualToString:@"ShowCal"]) {
        if ([segue.destinationViewController isKindOfClass:[ToDoCalViewController class]]) {
            ToDoCalViewController *calController = (ToDoCalViewController *)segue.destinationViewController;
            calController.events = self.events;
            calController.date = self.date;
        }
    } else if ([segue.identifier isEqualToString:@"AddEvent"]) {
        if ([segue.destinationViewController isKindOfClass:[AddItemViewController class]]) {
            AddItemViewController *addController = (AddItemViewController *)segue.destinationViewController;
            addController.addView = [[NewEventView alloc] init];
            addController.calendars = [self.store calendarsForEntityType:EKEntityTypeEvent];
            addController.addView.date = self.date;
            addController.transitioningDelegate = self;
            addController.modalPresentationStyle = UIModalPresentationCustom;
        }
    } else if ([segue.identifier isEqualToString:@"ShowSettings"]) {
        if ([segue.destinationViewController isKindOfClass:[SettingsViewController class]]) {
            SettingsViewController *settingsController = (SettingsViewController *)segue.destinationViewController;
            settingsController.transitioningDelegate = self;
            settingsController.modalPresentationStyle = UIModalPresentationCustom;
        }
    }
}

#pragma mark - Transitioning Delegate Methods

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    if ([presented isKindOfClass:[ListViewController class]]) {
        self.presentingList = YES;
        self.presentedList = YES;
    } else if ([presented isKindOfClass:[AddItemViewController class]]) {
        self.presentingAdd = YES;
        self.presentedAdd = YES;
    } else if ([presented isKindOfClass:[SettingsViewController class]]) {
        self.presentingSettings = YES;
        self.presentedSettings = YES;
    }
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    if ([dismissed isKindOfClass:[ListViewController class]]) self.presentingList = NO;
    else if ([dismissed isKindOfClass:[AddItemViewController class]]) self.presentingAdd = NO;
    else if ([dismissed isKindOfClass:[SettingsViewController class]]) self.presentingSettings = NO;
    return self;
}

#pragma mark - Animated Transitioning Protocol Methods

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if (self.presentedAdd) return 0.35;
    return 0.65f;
}

#define ANIMATION_INSET 40.0
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGRect endFrame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height);
    
    if (self.presentingList) {
        fromViewController.view.userInteractionEnabled = NO;
        
        [transitionContext.containerView addSubview:toViewController.view];
        [transitionContext.containerView addSubview:fromViewController.view];
        
        toViewController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.65, 0.65);
        endFrame.origin.y += self.view.frame.size.height;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                         animations:^{
                             fromViewController.view.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
                             fromViewController.view.frame = endFrame;
                             toViewController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
                         }completion:^(BOOL finished){
                             [transitionContext completeTransition:YES];
                         }];
    } else if (self.presentedList) {
        toViewController.view.userInteractionEnabled = YES;
        
        [transitionContext.containerView addSubview:fromViewController.view];
        [transitionContext.containerView addSubview:toViewController.view];
        
        toViewController.view.frame = CGRectMake(0.0, toViewController.view.frame.size.height, toViewController.view.frame.size.width, toViewController.view.frame.size.height);
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                         animations:^{
                             toViewController.view.frame = endFrame;
                             fromViewController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.65, 0.65);
                         }completion:^(BOOL finished){
                             self.presentedList = NO;
                             [transitionContext completeTransition:YES];
                         }];
    } else if (self.presentingAdd) {
        fromViewController.view.userInteractionEnabled = NO;
        
        [transitionContext.containerView addSubview:fromViewController.view];
        [transitionContext.containerView addSubview:toViewController.view];
        
        CGRect startFrame = endFrame;
        startFrame.origin.y += self.view.frame.size.height;
        
        toViewController.view.frame = startFrame;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                         animations:^{
                             fromViewController.view.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
                             toViewController.view.frame = endFrame;
                         }completion:^(BOOL finished){
                             [transitionContext completeTransition:YES];
                         }];
    } else if (self.presentedAdd) {
        toViewController.view.userInteractionEnabled = YES;
        
        [transitionContext.containerView addSubview:toViewController.view];
        [transitionContext.containerView addSubview:fromViewController.view];
        
        endFrame.origin.y += self.view.frame.size.height;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                         animations:^{
                             toViewController.view.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
                             fromViewController.view.frame = endFrame;
                         }completion:^(BOOL finished){
                             self.presentedAdd = NO;
                             [transitionContext completeTransition:YES];
                         }];
    } else if (self.presentingSettings) {
        toViewController.view.userInteractionEnabled = YES;
        
        [transitionContext.containerView addSubview:fromViewController.view];
        [transitionContext.containerView addSubview:toViewController.view];
        
        toViewController.view.frame = CGRectMake(0.0, toViewController.view.frame.size.height, toViewController.view.frame.size.width, toViewController.view.frame.size.height);
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                         animations:^{
                             toViewController.view.frame = endFrame;
                             fromViewController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.65, 0.65);
                         }completion:^(BOOL finished){
                             [transitionContext completeTransition:YES];
                         }];
    } else if (self.presentedSettings) {
        fromViewController.view.userInteractionEnabled = NO;
        
        [transitionContext.containerView addSubview:toViewController.view];
        [transitionContext.containerView addSubview:fromViewController.view];
        
        toViewController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.65, 0.65);
        endFrame.origin.y += self.view.frame.size.height;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                         animations:^{
                             fromViewController.view.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
                             fromViewController.view.frame = endFrame;
                             toViewController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
                         }completion:^(BOOL finished){
                             self.presentedSettings = NO;
                             [transitionContext completeTransition:YES];
                         }];
    }
}

- (IBAction)eventAdded:(UIStoryboardSegue *)segue
{
    if ([segue.sourceViewController isKindOfClass:[AddItemViewController class]]) {
        AddItemViewController *addController = (AddItemViewController *)segue.sourceViewController;
        if ([addController.addView isKindOfClass:[NewEventView class]]) {
            [self.store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error){
                if (!granted) return;
                NewEventView *newEventView = (NewEventView *)addController.addView;
                EKEvent *newEvent = [EKEvent eventWithEventStore:self.store];
                newEvent.title = newEventView.title;
                newEvent.location = newEventView.location;
                newEvent.calendar = newEventView.calendar;
                newEvent.allDay = newEventView.allDay;
                newEvent.startDate = newEventView.startDateRead;
                newEvent.endDate = newEventView.endDateRead;
                if (newEventView.recurrenceRule) newEvent.recurrenceRules = @[newEventView.recurrenceRule];
                newEvent.availability = (newEventView.busy) ? EKEventAvailabilityBusy : EKEventAvailabilityFree;
                newEvent.notes = newEventView.notes;
                NSError *err = nil;
                [self.store saveEvent:newEvent span:EKSpanFutureEvents error:&err];
                [self prepareForNewRequest];
                [self makeRequest];
            }];
        }
    }
}

- (IBAction)unwindListFromSummaryView:(UIStoryboardSegue *)segue { }

- (IBAction)flippedBackFromDayView:(UIStoryboardSegue *)segue { }

- (IBAction)dismissedSettings:(UIStoryboardSegue *)sengue { }

#pragma mark - Page View Controller Data Source Methods

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = ((PageContentViewController *) viewController).pageIndex;
    if (index == 0 || index == NSNotFound) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index = ((PageContentViewController *) viewController).pageIndex;
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.events count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (PageContentViewController *)viewControllerAtIndex:(NSInteger)index
{
    if ([self.events count] == 0 || index >= [self.events count]) {
        return nil;
    }
    
    PageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    pageContentViewController.event = [self.events objectAtIndex:index];
    
    NSInteger indexOfNextEvent = [self indexOfNextEvent];
    if (index < indexOfNextEvent) pageContentViewController.comingUpText = @"EARLIER:";
    else if (index == indexOfNextEvent) pageContentViewController.comingUpText = @"UP NEXT:";
    else if (index > indexOfNextEvent) pageContentViewController.comingUpText = @"LATER:";
    
    pageContentViewController.pageIndex = index;
    return pageContentViewController;
}

- (NSInteger)indexOfNextEvent
{
    NSInteger index = 0;
    EKEvent *nextEvent = [self.events objectAtIndex:index];
    while (nextEvent.startDate.timeIntervalSince1970 < [NSDate date].timeIntervalSince1970) {
        index++;
        if (index == [self.events count]) return index - 1;
        nextEvent = [self.events objectAtIndex:index];
    }
    return index;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.events count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return [self indexOfNextEvent];
}

#pragma mark - No Event Delegate Methods

- (void)noEventButtonPressed
{
    [self performSegueWithIdentifier:@"ShowList" sender:self];
}

@end
