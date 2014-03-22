//
//  DayView.m
//  SeniorProject
//
//  Created by Skylar Peterson on 1/28/14.
//  Copyright (c) 2014 SkylarPeterson. All rights reserved.
//

#import "DayView.h"
#import "CalEventView.h"
#import "Colors.h"
#import "Fonts.h"
#import "CalInfo.h"
#import <QuartzCore/QuartzCore.h>

@interface DayView() <UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *eventViews;

@end

#define HOUR_HEIGHT 120.0

@implementation DayView

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (void)initDayView
{
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width, HOUR_HEIGHT * 24);
    
    for (int i = 0; i <= 24; i++) {
        CGFloat y = i * HOUR_HEIGHT;
        [self addLineFromPoint:CGPointMake(0.0, y) toPoint:CGPointMake(self.frame.size.width, y)];
        
        CGFloat hourLabelY = i * HOUR_HEIGHT - 20.0;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5.0, hourLabelY, 75.0, 20.0)];
        //label.text = (i == 12) ? @"Noon" : (i == 0 || i == 24) ? @"Midnight" : [NSString stringWithFormat:@"%i", (i > 12) ? i % 12 : i];
        label.text = [NSString stringWithFormat:@"%i", (i > 12) ?  (i == 24 || i == 0) ? 12 : i % 12 : i];
        label.textColor = [Colors secondarGrayColor];
        label.font = [Fonts dayTimesFont];
        [self.scrollView addSubview:label];
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initDayView];
    }
    return self;
}

#define EVENT_VIEW_INSET 40.0
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.scrollView.frame = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height);
    
    NSMutableArray *eventViews = [[NSMutableArray alloc] init];
    for (EKEvent *event in self.events) {
        NSString *startTime = [CalInfo timeStringFromDate:event.startDate with12HourFormat:NO];
        NSString *endTime = [CalInfo timeStringFromDate:event.endDate with12HourFormat:NO];
        
        NSString *startFirstNums = [startTime substringToIndex:2];
        NSString *startSecondNums = [startTime substringWithRange:NSMakeRange(3, 2)];
        NSString *endFirstNums = [endTime substringToIndex:2];
        NSString *endSecondNums = [endTime substringWithRange:NSMakeRange(3, 2)];
        
        CGFloat y = startFirstNums.intValue * HOUR_HEIGHT + (startSecondNums.intValue/5.0)*10.0;
        CGFloat height = (endFirstNums.intValue - startFirstNums.intValue)*HOUR_HEIGHT + (endSecondNums.intValue - startSecondNums.intValue)*10.0;
        if (y + height > 24 * HOUR_HEIGHT) height = (24 * HOUR_HEIGHT) - y;
        
        CalEventView *eventView = [[CalEventView alloc] initWithFrame:CGRectMake(EVENT_VIEW_INSET, y, self.scrollView.frame.size.width - EVENT_VIEW_INSET, height)];
        eventView.event = event;
        [eventViews addObject:eventView];
        [self.scrollView addSubview:eventView];
    }
    self.eventViews = [eventViews copy];
    if([self.eventViews count] > 0) [self.scrollView scrollRectToVisible:((CalEventView *)[self.eventViews objectAtIndex:0]).frame animated:NO];
}

- (void)addLineFromPoint:(CGPoint)from toPoint:(CGPoint)to
{
//    if ([[[self.scrollView layer] sublayers] objectAtIndex:0])
//    {
//        self.scrollView.layer.sublayers = nil;
//    }
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
//    [shapeLayer setBounds:self.bounds];
//    [shapeLayer setPosition:self.center];
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    [shapeLayer setStrokeColor:[[Colors lightestGrayColor] CGColor]];
    [shapeLayer setLineWidth:1.0f];
    [shapeLayer setLineJoin:kCALineJoinRound];
    [shapeLayer setLineDashPattern:
     [NSArray arrayWithObjects:[NSNumber numberWithInt:5],
      [NSNumber numberWithInt:5],nil]];
    
    // Setup the path
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, from.x, from.y);
    CGPathAddLineToPoint(path, NULL, to.x, to.y);
    
    [shapeLayer setPath:path];
    CGPathRelease(path);
    
    [[self.scrollView layer] addSublayer:shapeLayer];
}

@end
