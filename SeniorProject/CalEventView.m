//
//  CalEventView.m
//  SeniorProject
//
//  Created by Skylar Peterson on 2/3/14.
//  Copyright (c) 2014 SkylarPeterson. All rights reserved.
//

#import "CalEventView.h"

#import "Colors.h"
#import "Fonts.h"
#import "CalInfo.h"

@interface CalEventView()

@property (nonatomic, strong) UILabel *mainEventTitle;
@property (nonatomic, strong) UILabel *eventLocation;
@property (nonatomic, strong) CALayer *divider;
@property (nonatomic, strong) UILabel *endTimeLabel;

@end

@implementation CalEventView

- (void)setEvent:(EKEvent *)event
{
    _event = event;
    self.mainEventTitle.text = event.title;
    self.eventLocation.text = event.location;
    self.endTimeLabel.text = [NSString stringWithFormat:@"Ends %@", [CalInfo timeStringFromDate:event.endDate with12HourFormat:YES]];
    self.backgroundColor = [UIColor colorWithCGColor:event.calendar.CGColor];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [Colors mainGrayColor];
        self.clipsToBounds = NO;
        
        self.mainEventTitle = [[UILabel alloc] init];
        self.mainEventTitle.textColor = [UIColor whiteColor];
        self.mainEventTitle.font = [Fonts eventMainTitleFont];
        [self addSubview:self.mainEventTitle];
        
        self.eventLocation = [[UILabel alloc] init];
        self.eventLocation.textColor = [UIColor whiteColor];
        self.eventLocation.font = [Fonts locationFont];
        [self addSubview:self.eventLocation];
        
        self.divider = [CALayer layer];
        self.divider.backgroundColor = [[UIColor whiteColor] CGColor];
        [self.layer addSublayer:self.divider];
        
        self.endTimeLabel = [[UILabel alloc] init];
        self.endTimeLabel.textColor = [UIColor whiteColor];
        self.endTimeLabel.textAlignment = NSTextAlignmentRight;
        self.endTimeLabel.font = [Fonts endTimeFont];
        [self addSubview:self.endTimeLabel];
        
        [self setMaskTo:self byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft];
    }
    return self;
}

#define LABEL_INSET 10.0
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.mainEventTitle.frame = CGRectMake(LABEL_INSET, LABEL_INSET, self.frame.size.width - 2 * LABEL_INSET, 30.0);
    self.eventLocation.frame = CGRectMake(LABEL_INSET, 40.0, self.frame.size.width - 2 * LABEL_INSET, 20.0);
    self.divider.frame = CGRectMake(LABEL_INSET, self.frame.size.height - 2 * LABEL_INSET, self.frame.size.width - 2 * LABEL_INSET, 0.5);
    self.endTimeLabel.frame = CGRectMake(self.frame.size.width - LABEL_INSET - 100.0, self.frame.size.height - 2 *LABEL_INSET, 100.0, 2 * LABEL_INSET);
}

- (void)setMaskTo:(UIView*)view byRoundingCorners:(UIRectCorner)corners
{
    UIBezierPath *rounded = [UIBezierPath bezierPathWithRoundedRect:view.bounds
                                                  byRoundingCorners:corners
                                                        cornerRadii:CGSizeMake(12.0, 12.0)];
    CAShapeLayer *shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    view.layer.mask = shape;
}

@end
