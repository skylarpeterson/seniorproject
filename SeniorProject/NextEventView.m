//
//  NextEventView.m
//  One
//
//  Created by Skylar Peterson on 2/24/14.
//  Copyright (c) 2014 SkylarPeterson. All rights reserved.
//

#import "NextEventView.h"

#import "Fonts.h"
#import "Colors.h"
#import "Methods.h"
#import "CalInfo.h"

@interface NextEventView()

@property (nonatomic, strong) UILabel *comingNextLabel;
@property (nonatomic, strong) UIView *calendarColorView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *locationLabel;

@end

@implementation NextEventView

- (UILabel *)comingNextLabel
{
    if(!_comingNextLabel) _comingNextLabel = [[UILabel alloc] init];
    return _comingNextLabel;
}

- (UIView *)calendarColorView
{
    if(!_calendarColorView) _calendarColorView = [[UIView alloc] init];
    return _calendarColorView;
}

- (UILabel *)titleLabel
{
    if(!_titleLabel) _titleLabel = [[UILabel alloc] init];
    return _titleLabel;
}

- (UILabel *)locationLabel
{
    if(!_locationLabel) _locationLabel = [[UILabel alloc] init];
    return _locationLabel;
}

- (void)setEvent:(EKEvent *)event
{
    _event = event;
    self.titleLabel.text = event.title;
    
    NSString *firstTime = [CalInfo timeStringFromDate:event.startDate with12HourFormat:YES];
    NSString *secondTime = [CalInfo timeStringFromDate:event.endDate with12HourFormat:YES];
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@", firstTime, secondTime]];
    [attributedText addAttribute:NSFontAttributeName
                            value:[Fonts nextEventTimeFont]
                            range:NSMakeRange(0, [firstTime length] - 2)];
    [attributedText addAttribute:NSFontAttributeName
                            value:[Fonts nextEventTimeDistinctionFont]
                            range:NSMakeRange([firstTime length] - 2, 2)];
    [attributedText addAttribute:NSFontAttributeName
                            value:[Fonts nextEventTimeFont]
                            range:NSMakeRange([firstTime length] + 2, [secondTime length] - 2)];
    [attributedText addAttribute:NSFontAttributeName
                            value:[Fonts nextEventTimeDistinctionFont]
                            range:NSMakeRange([firstTime length] + [secondTime length] - 1, 2)];
    
    
    self.timeLabel.attributedText = attributedText;
    
    NSString *location = @"None";
    if (event.location) location = event.location;
    self.locationLabel.text = [NSString stringWithFormat:@"Location:\n%@", location];
    
    self.calendarColorView.backgroundColor =  [UIColor colorWithCGColor:event.calendar.CGColor];
}

- (void)setComingUpText:(NSString *)comingUpText
{
    _comingUpText = comingUpText;
    self.comingNextLabel.text = comingUpText;
}

- (void)initialize
{
    self.backgroundColor = [UIColor whiteColor];
    
    self.comingNextLabel = [self nextEventViewLabelWithText:@"UP NEXT:" andFont:[Fonts nextEventComingUpFont]];
    self.comingNextLabel.textColor = [UIColor whiteColor];
    self.comingNextLabel.textAlignment = NSTextAlignmentLeft;
    
    self.calendarColorView.backgroundColor = [Colors mainGrayColor];
    
    self.titleLabel = [self nextEventViewLabelWithText:@"" andFont:[Fonts nextEventTitleFont]];
    //self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.numberOfLines = 4;
    
    self.timeLabel = [self nextEventViewLabelWithText:@"" andFont:[Fonts nextEventTimeFont]];
    self.timeLabel.numberOfLines = 2;
    //self.timeLabel.textAlignment = NSTextAlignmentLeft;
    
    self.locationLabel = [self nextEventViewLabelWithText:@"" andFont:[Fonts nextEventLocationFont]];
    self.locationLabel.numberOfLines = 4;
    
    [self addSubview:self.calendarColorView];
    [self addSubview:self.comingNextLabel];
    [self addSubview:self.titleLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.locationLabel];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

#define PAGE_CONTROL_HEIGHT 37.0
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize size = [Methods sizeForText:self.comingNextLabel.text withWidth:self.frame.size.width andFont:self.comingNextLabel.font];
    self.comingNextLabel.frame = CGRectMake(0.0, 0.0, self.frame.size.width, size.height + 5.0);
    self.calendarColorView.frame = CGRectMake(-10.0, 0.0, self.frame.size.width + 20.0, self.comingNextLabel.frame.size.height);
    self.titleLabel.frame = CGRectMake(0.0, self.comingNextLabel.frame.origin.y + self.comingNextLabel.frame.size.height, self.frame.size.width, self.frame.size.height/3.0);
    self.timeLabel.frame = CGRectMake(0.0, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height, self.frame.size.width/2.0, self.frame.size.height - self.titleLabel.frame.size.height - self.comingNextLabel.frame.size.height - PAGE_CONTROL_HEIGHT);
    self.locationLabel.frame = CGRectMake(self.frame.size.width/2.0, self.timeLabel.frame.origin.y, self.timeLabel.frame.size.width, self.timeLabel.frame.size.height);
}

- (UILabel *)nextEventViewLabelWithText:(NSString *)text andFont:(UIFont *)font
{
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = [Colors mainGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = font;
    return label;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
