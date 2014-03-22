//
//  NoEventsView.m
//  One
//
//  Created by Skylar Peterson on 3/16/14.
//  Copyright (c) 2014 SkylarPeterson. All rights reserved.
//

#import "NoEventsView.h"
#import "Fonts.h"
#import "Colors.h"

@interface NoEventsView()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UILabel *label;

@end

@implementation NoEventsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NoEventIcon.png"]];
        
        self.button = [[UIButton alloc] init];
        [self.button addTarget:self action:@selector(buttonTapped) forControlEvents:UIControlEventTouchUpInside];
        [self.button setBackgroundImage:[UIImage imageNamed:@"NoEventIcon.png"] forState:UIControlStateNormal];
        
        self.label = [[UILabel alloc] init];
        self.label.text = @"You have no events for today. Add a new one to see your day's summary, or press the 'One' icon to look at today's tasks.";
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.textColor = [Colors mainGrayColor];
        self.label.font = [Fonts titleFont];
        self.label.numberOfLines = 5;
        
        //[self addSubview:self.imageView];
        [self addSubview:self.button];
        [self addSubview:self.label];
    }
    return self;
}

#define INSET 10.0
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.button.frame = CGRectMake(self.frame.size.width/2.0 - IMAGE_VIEW_SIZE/2.0, 0.0, IMAGE_VIEW_SIZE, IMAGE_VIEW_SIZE);
    //self.imageView.frame = CGRectMake(self.frame.size.width/2.0 - IMAGE_VIEW_SIZE/2.0, 0.0, IMAGE_VIEW_SIZE, IMAGE_VIEW_SIZE);
    self.label.frame = CGRectMake(INSET, IMAGE_VIEW_SIZE, self.frame.size.width - 2*INSET, 1.25*IMAGE_VIEW_SIZE);
}

- (void)buttonTapped
{
    [self.delegate noEventButtonPressed];
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
