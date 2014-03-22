//
//  CalendarCell.m
//  One
//
//  Created by Skylar Peterson on 2/27/14.
//  Copyright (c) 2014 SkylarPeterson. All rights reserved.
//

#import "CalendarCell.h"
#import "CircleView.h"
#import "Colors.h"
#import "Fonts.h"
#import "Methods.h"

@interface CalendarCell()

@property (nonatomic, strong) CircleView *circleView;
@property (nonatomic, strong) UILabel *calendarLabel;

@end

@implementation CalendarCell

- (void)setCalendarColor:(UIColor *)calendarColor
{
    _calendarColor = calendarColor;
    CGRect circleViewFrame = CGRectNull;
    if (self.circleView) {
        circleViewFrame = self.circleView.frame;
        [self.circleView removeFromSuperview];
    }
    self.circleView = [[CircleView alloc] initWithColor:calendarColor];
    self.circleView.frame = circleViewFrame;
    [self addSubview:self.circleView];
}

- (void)setCalendarName:(NSString *)calendarName
{
    _calendarName = calendarName;
    self.calendarLabel.text = calendarName;
}

- (void)setFont:(UIFont *)font
{
    _font = font;
    self.calendarLabel.font = font;
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    self.calendarLabel.textColor = textColor;
}

- (void)initialize
{
    self.backgroundColor = [UIColor clearColor];
    self.calendarLabel = [[UILabel alloc] init];
    [self addSubview:self.calendarLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize textSize = [Methods sizeForText:self.calendarLabel.text withWidth:self.frame.size.width - self.circleSize - 2*INSET andFont:self.calendarLabel.font];
    self.calendarLabel.numberOfLines = textSize.height / [Methods sizeForText:@"A" withWidth:self.frame.size.width - self.circleSize - 2*INSET andFont:self.calendarLabel.font].height + 1;
    self.calendarLabel.frame = CGRectMake(self.circleSize + 2*INSET, self.frame.size.height/2.0 - textSize.height/2.0, self.frame.size.width - self.circleSize - 2*INSET, textSize.height);
    self.circleView.frame = CGRectMake(INSET, self.frame.size.height/2.0 - self.circleSize/2.0, self.circleSize, self.circleSize);
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self.circleView removeFromSuperview];
}

@end
