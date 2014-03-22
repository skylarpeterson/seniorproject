//
//  DaysView.m
//  SeniorProject
//
//  Created by Skylar Peterson on 1/21/14.
//  Copyright (c) 2014 SkylarPeterson. All rights reserved.
//

#import "DaysView.h"

@interface DaysView()
@property (nonatomic, strong) NSArray *dayLabels;
@end

@implementation DaysView

+ (NSArray *)initialsOfTheWeek
{
    return @[@"Su", @"M", @"T", @"W", @"Th", @"F", @"Sa"];
}

+ (NSArray *)daysOfTheWeek
{
    return @[@"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSMutableArray *tempLabels = [[NSMutableArray alloc] init];
        for (int i = 0; i < 7; i++) {
            UILabel *dayLabel = [[UILabel alloc] init];
            dayLabel.text = [[DaysView initialsOfTheWeek] objectAtIndex:i];
            dayLabel.textAlignment = NSTextAlignmentCenter;
            [tempLabels addObject:dayLabel];
            [self addSubview:dayLabel];
        }
        self.dayLabels = [tempLabels copy];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSMutableArray *tempLabels = [[NSMutableArray alloc] init];
        for (int i = 0; i < 7; i++) {
            UILabel *dayLabel = [[UILabel alloc] init];
            dayLabel.text = [[DaysView daysOfTheWeek] objectAtIndex:i];
            dayLabel.textAlignment = NSTextAlignmentCenter;
            dayLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.25];
            [tempLabels addObject:dayLabel];
            [self addSubview:dayLabel];
        }
        self.dayLabels = [tempLabels copy];
    }
    return self;
}

- (void)layoutSubviews
{
    NSLog(@"%f", self.frame.size.width/7.0);
    [super layoutSubviews];
    for (int i = 0; i < 7; i++) {
        UILabel *dayLabel = [self.dayLabels objectAtIndex:i];
        dayLabel.frame = CGRectMake(self.frame.size.width/7.0 * i, 0.0, self.frame.size.width/7.0, 20.0);
    }
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
