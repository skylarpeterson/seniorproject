//
//  TaskSummaryView.m
//  One
//
//  Created by Skylar Peterson on 3/14/14.
//  Copyright (c) 2014 SkylarPeterson. All rights reserved.
//

#import "TaskSummaryView.h"
#import "Fonts.h"
#import "Colors.h"

@interface TaskSummaryView()

@property (nonatomic, strong) UILabel *mainLabel;
@property (nonatomic, strong) UILabel *tasksLeftLabel;
@property (nonatomic, strong) UILabel *numTasksLeftLabel;
@property (nonatomic, strong) UILabel *tasksCompleteLabel;
@property (nonatomic, strong) UILabel *numTasksCompleteLabel;

@end

@implementation TaskSummaryView

- (void)setNumLeft:(NSInteger)numLeft
{
    _numLeft = numLeft;
    self.numTasksLeftLabel.text = [NSString stringWithFormat:@"%li", numLeft];
}

- (void)setNumCompleted:(NSInteger)numCompleted
{
    _numCompleted = numCompleted;
    self.numTasksCompleteLabel.text = [NSString stringWithFormat:@"%li", numCompleted];
}

- (void)initialize
{
    self.mainLabel = [self labelWithText:@"Task Digest" andTextAlignment:NSTextAlignmentCenter];
    self.tasksLeftLabel = [self labelWithText:@"Left:" andTextAlignment:NSTextAlignmentRight];
    self.numTasksLeftLabel = [self labelWithText:[NSString stringWithFormat:@"%li", self.numLeft] andTextAlignment:NSTextAlignmentCenter];
    self.tasksCompleteLabel = [self labelWithText:@"Finished:" andTextAlignment:NSTextAlignmentRight];
    self.numTasksCompleteLabel = [self labelWithText:[NSString stringWithFormat:@"%li", self.numCompleted] andTextAlignment:NSTextAlignmentCenter];
    
    [self addSubview:self.mainLabel];
    [self addSubview:self.tasksLeftLabel];
    [self addSubview:self.numTasksLeftLabel];
    [self addSubview:self.tasksCompleteLabel];
    [self addSubview:self.numTasksCompleteLabel];
}

- (UILabel *)labelWithText:(NSString *)text andTextAlignment:(NSTextAlignment)textAlignment
{
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = [Colors mainGrayColor];
    label.textAlignment = textAlignment;
    label.font = [Fonts nextEventTimeDistinctionFont];
    return label;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

#define INSET 10.0
#define NUMBER_SIZE 35.0
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.mainLabel.frame = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height/3.0);
    self.tasksLeftLabel.frame = CGRectMake(0.0, self.frame.size.height/3.0, self.frame.size.width - NUMBER_SIZE - INSET, self.frame.size.height/3.0);
    self.numTasksLeftLabel.frame = CGRectMake(self.frame.size.width - NUMBER_SIZE, self.frame.size.height/3.0, NUMBER_SIZE, self.frame.size.height/3.0);
    self.tasksCompleteLabel.frame = CGRectMake(0.0, 2.0*self.frame.size.height/3.0, self.frame.size.width - NUMBER_SIZE - INSET, self.frame.size.height/3.0);
    self.numTasksCompleteLabel.frame = CGRectMake(self.frame.size.width - NUMBER_SIZE, 2.0*self.frame.size.height/3.0, NUMBER_SIZE, self.frame.size.height/3.0);
}

@end
