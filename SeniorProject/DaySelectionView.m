//
//  DaySelectionView.m
//  SeniorProject
//
//  Created by Skylar Peterson on 1/27/14.
//  Copyright (c) 2014 SkylarPeterson. All rights reserved.
//

#import "DaySelectionView.h"
#import "Fonts.h"
#import "Colors.h"

@interface DaySelectionView() <UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSArray *labels;
@property (nonatomic, strong) NSArray *dateLabels;
@property (nonatomic, strong) NSArray *dividers;
@property (nonatomic, strong) UIView *selectedBackground;

@property (nonatomic) CGPoint originalCenter;

@end

@implementation DaySelectionView

+ (NSArray *)initialsOfTheWeek
{
    return @[@"S", @"M", @"T", @"W", @"T", @"F", @"S"];
}

- (void)setDates:(NSArray *)dates
{
    _dates = dates;
    for (int i = 0; i < [dates count]; i++) {
        UILabel *dateLabel = [self.dateLabels objectAtIndex:i];
        NSNumber *date = [dates objectAtIndex:i];
        dateLabel.text = [NSString stringWithFormat:@"%i", date.intValue];
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    UILabel *selectedLabel = [self.labels objectAtIndex:selectedIndex];
    self.selectedBackground.frame = CGRectMake(selectedLabel.frame.origin.x, selectedLabel.frame.origin.y, self.frame.size.width/7.0, self.frame.size.height);
}

- (void)initView
{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderColor = [[Colors lightestGrayColor] CGColor];
    self.layer.borderWidth = 1.5;
    
    self.selectedBackground = [[UIView alloc] init];
    self.selectedBackground.backgroundColor = [Colors lightestGrayColor];
    [self addSubview:self.selectedBackground];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dayTapped:)];
    [self addGestureRecognizer:tapGesture];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dayPanned:)];
    [self addGestureRecognizer:panGesture];
    
    NSMutableArray *tempLabelsArr = [[NSMutableArray alloc] init];
    NSMutableArray *tempDateLabelsArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < [[DaySelectionView initialsOfTheWeek] count]; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.text = [[DaySelectionView initialsOfTheWeek] objectAtIndex:i];
        label.textColor = [Colors mainGrayColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [Fonts dayBarFont];
        
        UILabel *dateLabel = [[UILabel alloc] init];
        dateLabel.textColor = [Colors mainGrayColor];
        dateLabel.textAlignment = NSTextAlignmentCenter;
        dateLabel.font = [Fonts dayBarNumberFont];
        
        [tempLabelsArr addObject:label];
        [tempDateLabelsArr addObject:dateLabel];
        [self addSubview:label];
        [self addSubview:dateLabel];
    }
    
    NSMutableArray *tempDividersArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < [[DaySelectionView initialsOfTheWeek] count] - 1; i++) {
        UIView *divider = [[UIView alloc] init];
        divider.backgroundColor = [Colors lightestGrayColor];
        [tempDividersArr addObject:divider];
        [self addSubview:divider];
    }
    
    self.labels = [tempLabelsArr copy];
    self.dateLabels = [tempDateLabelsArr copy];
    self.dividers = [tempDividersArr copy];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (int i = 0; i < [[DaySelectionView initialsOfTheWeek] count]; i++) {
        UILabel *label = [self.labels objectAtIndex:i];
        CGFloat width = self.frame.size.width / 7.0;
        label.frame = CGRectMake(i * width, 0, width, self.frame.size.height/2.0);
        
        UILabel *dateLabel = [self.dateLabels objectAtIndex:i];
        dateLabel.frame = CGRectMake(i * width, self.frame.size.height/2.0, width, self.frame.size.height/2.0);
    }
    
    for (int i = 1; i < [[DaySelectionView initialsOfTheWeek] count]; i++) {
        UIView *divider = [self.dividers objectAtIndex:i - 1];
        CGFloat separation = self.frame.size.width / 7.0;
        divider.frame = CGRectMake(i * separation, 0, 1.5, self.frame.size.height);
    }
    
    self.selectedBackground.frame = CGRectMake(self.selectedIndex * self.frame.size.width/7.0, 0.0, self.frame.size.width/7.0, self.frame.size.height);
}

#pragma mark - Gesture Recognizing Methods

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:[self superview]];
        if(fabsf(translation.x) < fabsf(translation.y)){
            return NO;
        }
    }
    return YES;
}

- (void)dayTapped:(UITapGestureRecognizer *)recognizer
{
    CGPoint touchPoint = [recognizer locationInView:self];
    int index = touchPoint.x / (self.frame.size.width / 7.0);
    UILabel *labelTapped = [self.labels objectAtIndex:index];
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                        self.selectedBackground.frame = CGRectMake(labelTapped.frame.origin.x, labelTapped.frame.origin.y, self.frame.size.width/7.0, self.frame.size.height);
                     }completion:nil];
}

- (void)dayPanned:(UIPanGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self.delegate daySelectionViewPanningBegan];
    }
    if (recognizer.state == UIGestureRecognizerStateChanged){
        [self.delegate daySelectionViewPanningChanged:[recognizer translationInView:self]];
    }
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [self.delegate daySelectionViewPanningEnded];
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
