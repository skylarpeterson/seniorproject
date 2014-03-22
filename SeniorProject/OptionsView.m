//
//  OptionsView.m
//  SeniorProject
//
//  Created by Skylar Peterson on 2/10/14.
//  Copyright (c) 2014 SkylarPeterson. All rights reserved.
//

#import "OptionsView.h"
#import "Fonts.h"

@interface OptionsView() <UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSArray *tabs;

@end

@implementation OptionsView

- (void)setOptions:(NSArray *)options
{
    _options = options;
    if (self.tabs) {
        for (int i = 0; i < [options count]; i++) {
            UILabel *tab = [self.tabs objectAtIndex:i];
            tab.text = [options objectAtIndex:i];
        }
    } else {
        [self initializeView];
    }
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    for (int i = 0; i < [self.tabs count]; i++) {
        UILabel *tab = [self.tabs objectAtIndex:i];
        tab.textColor = textColor;
    }
}

- (void)setUnselectedColor:(UIColor *)unselectedColor
{
    _unselectedColor = unselectedColor;
    for (int i = 0; i < [self.tabs count]; i++) {
        UILabel *tab = [self.tabs objectAtIndex:i];
        tab.backgroundColor = unselectedColor;
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    if (selectedIndex != -1) {
        UILabel *selectedTab = [self.tabs objectAtIndex:selectedIndex];
        selectedTab.backgroundColor = [UIColor clearColor];
        selectedTab.font = [Fonts optionsViewSelectedTabFont];
    } else {
        for (UILabel *tab in self.tabs) {
            tab.backgroundColor = self.unselectedColor;
            tab.font = [Fonts optionsViewUnselectedTabFont];
        }
    }
}

#define BORDER_INSET 1.5
- (void)initializeView
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tabTapped:)];
    [self addGestureRecognizer:tapGesture];
    NSMutableArray *mutableTabs = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self.options count]; i++) {
        UILabel *tab = [[UILabel alloc] initWithFrame:CGRectMake(i * self.frame.size.width/[self.options count] + BORDER_INSET/2.0, BORDER_INSET, self.frame.size.width/[self.options count] - BORDER_INSET, self.frame.size.height - 2 * BORDER_INSET)];
        tab.text = [self.options objectAtIndex:i];
        tab.textAlignment = NSTextAlignmentCenter;
        tab.font = [Fonts optionsViewUnselectedTabFont];
        [self addSubview:tab];
        [mutableTabs addObject:tab];
    }
    self.tabs = [mutableTabs copy];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    for (int i = 0; i < [self.tabs count]; i++) {
        UILabel *tab = [self.tabs objectAtIndex:i];
        tab.frame = CGRectMake(i * self.frame.size.width/[self.options count] + BORDER_INSET/2.0, BORDER_INSET, self.frame.size.width/[self.options count] - BORDER_INSET, self.frame.size.height - 2 * BORDER_INSET);
    }
}

#pragma mark - Gesture Recognizer Methods

- (void)tabTapped:(UITapGestureRecognizer *)recognizer
{
    CGPoint touchPoint = [recognizer locationInView:self];
    int index = touchPoint.x / (self.frame.size.width / [self.options count]);
    
    if (self.selectedIndex != -1) {
        UILabel *previouslySelected = [self.tabs objectAtIndex:self.selectedIndex];
        previouslySelected.backgroundColor = self.unselectedColor;
        previouslySelected.font = [Fonts optionsViewUnselectedTabFont];
    }
    self.selectedIndex = index;
    
    UILabel *labelTapped = [self.tabs objectAtIndex:index];
    labelTapped.backgroundColor = [UIColor clearColor];
    labelTapped.font = [Fonts optionsViewSelectedTabFont];
    
    [self.delegate selectedIndexChangedToIndex:index];
}

@end
