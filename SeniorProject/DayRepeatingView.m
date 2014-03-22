//
//  DayRepeatingView.m
//  One
//
//  Created by Skylar Peterson on 3/17/14.
//  Copyright (c) 2014 SkylarPeterson. All rights reserved.
//

#import "DayRepeatingView.h"
#import "Fonts.h"
#import "Colors.h"
#import "CalInfo.h"

@interface DayRepeatingView()

@property (nonatomic, strong) NSArray *buttons;

@end

@implementation DayRepeatingView

- (void)initialize
{
    NSMutableArray *mutableButtons = [[NSMutableArray alloc] init];
    NSDictionary *daysOfTheWeek = [CalInfo weekdaysForNums];
    for (int i = 0; i < 7; i++) {
        UIButton *button = [[UIButton alloc] init];
        [button setBackgroundImage:[UIImage imageNamed:@"CircleLight.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"CircleLightFilled.png"] forState:UIControlStateSelected];
        NSString *weekday = [daysOfTheWeek objectForKey:[NSNumber numberWithInt:i]];
        [button setTitle:[weekday substringToIndex:1] forState:UIControlStateNormal];
        [button setTitleColor:[Colors lightestGrayColor] forState:UIControlStateNormal];
        [button setTitleColor:[Colors mainGrayColor] forState:UIControlStateSelected];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.titleLabel.font = [Fonts addItemSubtitleFont];
        
        [button addTarget:self action:@selector(buttonSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
        [mutableButtons addObject:button];
    }
    self.buttons = [mutableButtons copy];
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
    CGFloat interSpace = (self.frame.size.width/([self.buttons count])) - BUTTON_SIZE;
    for (int i = 0; i < [self.buttons count]; i++) {
        UIButton *button = [self.buttons objectAtIndex:i];
        CGFloat x = (i == 0) ? interSpace/2.0 : i*BUTTON_SIZE + i*interSpace + interSpace/2.0;
        button.frame = CGRectMake(x, 0.0, BUTTON_SIZE, BUTTON_SIZE);
    }
}

- (void)buttonSelected:(UIButton *)button
{
    if (button.selected) {
        button.selected = NO;
    } else {
        button.selected = YES;
    }
}

@end
