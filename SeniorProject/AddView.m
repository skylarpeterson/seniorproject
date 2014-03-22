//
//  AddView.m
//  SeniorProject
//
//  Created by Skylar Peterson on 2/10/14.
//  Copyright (c) 2014 SkylarPeterson. All rights reserved.
//

#import "AddView.h"
#import "Colors.h"
#import "Fonts.h"

@interface AddView()

@property (nonatomic, strong) UILabel *createLabel;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UIView *horizontalDivide;
@property (nonatomic, strong) UIView *verticalDivide;

@end

@implementation AddView

#define TITLE_LABEL_HEIGHT 50.0
#define MAIN_BUTTON_HEIGHT 65.0
#define DIVIDE_INSET 10.0

- (UIScrollView *)scrollView
{
    if (!_scrollView) _scrollView = [[UIScrollView alloc] init];
    return _scrollView;
}

- (UILabel *)createLabel
{
    if (!_createLabel) _createLabel = [[UILabel alloc] init];
    return _createLabel;
}

- (UIButton *)cancelButton
{
    if (!_cancelButton) _cancelButton = [[UIButton alloc] init];
    return _cancelButton;
}

- (UIButton *)saveButton
{
    if (!_saveButton) _saveButton = [[UIButton alloc] init];
    return _saveButton;
}

- (UIView *)horizontalDivide
{
    if (!_horizontalDivide) _horizontalDivide = [[UIView alloc] init];
    return _horizontalDivide;
}

- (UIView *)verticalDivide
{
    if (!_verticalDivide) _verticalDivide = [[UIView alloc] init];
    return _verticalDivide;
}

- (CalendarCell *)calendarCell
{
    if (!_calendarCell) _calendarCell = [[CalendarCell alloc] init];
    return _calendarCell;
}

- (void)setTitleText:(NSString *)titleText
{
    _titleText = titleText;
    self.createLabel.text = titleText;
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    self.createLabel.textColor = textColor;
    [self.cancelButton setTitleColor:textColor forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:self.backgroundColor forState:UIControlStateHighlighted];
    [self.cancelButton setBackgroundImage:[self imageWithColor:textColor] forState:UIControlStateHighlighted];
    [self.saveButton setTitleColor:textColor forState:UIControlStateNormal];
    [self.saveButton setTitleColor:self.backgroundColor forState:UIControlStateHighlighted];
    [self.saveButton setBackgroundImage:[self imageWithColor:textColor] forState:UIControlStateHighlighted];
    self.horizontalDivide.backgroundColor = textColor;
    self.verticalDivide.backgroundColor = textColor;
}

- (void)initializeSuper
{
    self.layer.cornerRadius = 10.0;
    self.clipsToBounds = YES;
    self.createLabel.textAlignment = NSTextAlignmentCenter;
    self.createLabel.font = [Fonts addItemTitleFont];
    
    self.scrollView.alwaysBounceVertical = YES;
    
    [self.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    self.cancelButton.titleLabel.font = [Fonts addItemButtonFont];
    [self.cancelButton addTarget:self action:@selector(cancelTapped) forControlEvents:UIControlEventTouchUpInside];
    
    [self.saveButton setTitle:@"Create" forState:UIControlStateNormal];
    self.saveButton.titleLabel.font = [Fonts addItemButtonFont];
    [self.saveButton addTarget:self action:@selector(saveTapped) forControlEvents:UIControlEventTouchUpInside];
    
    self.calendarCell.calendarColor = [Colors mainGrayColor];
    self.calendarCell.calendarName = @"None";
    self.calendarCell.font = [Fonts addItemSubtitleFont];
    self.calendarCell.textColor = [Colors mainGrayColor];
    self.calendarCell.circleSize = 20.0;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(calendarCellTapped)];
    [self.calendarCell addGestureRecognizer:tapGesture];
    
    [self addSubview:self.scrollView];
    [self addSubview:self.createLabel];
    [self addSubview:self.cancelButton];
    [self addSubview:self.saveButton];
    [self addSubview:self.horizontalDivide];
    [self addSubview:self.verticalDivide];
    [self.scrollView addSubview:self.calendarCell];
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initializeSuper];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeSuper];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.createLabel.frame = CGRectMake(0.0, 0.0, self.frame.size.width, TITLE_LABEL_HEIGHT);
    self.scrollView.frame = CGRectMake(0.0, TITLE_LABEL_HEIGHT, self.frame.size.width, self.frame.size.height - TITLE_LABEL_HEIGHT - MAIN_BUTTON_HEIGHT);
    self.cancelButton.frame = CGRectMake(0.0, self.frame.size.height - MAIN_BUTTON_HEIGHT, self.frame.size.width/2.0, MAIN_BUTTON_HEIGHT);
    self.saveButton.frame = CGRectMake(self.frame.size.width/2.0, self.frame.size.height - MAIN_BUTTON_HEIGHT, self.frame.size.width/2.0, MAIN_BUTTON_HEIGHT);
    
    self.horizontalDivide.frame = CGRectMake(0.0, self.frame.size.height - MAIN_BUTTON_HEIGHT, self.frame.size.width, 0.5);
    self.verticalDivide.frame = CGRectMake(self.frame.size.width/2.0, self.frame.size.height - MAIN_BUTTON_HEIGHT, 0.5, MAIN_BUTTON_HEIGHT );
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UILabel *)labelWithText:(NSString *)text
{
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = self.textColor;
    label.font = [Fonts addItemSubtitleFont];
    return label;
}

#pragma mark - Button Response Methods

- (void)cancelTapped
{
    [self.delegate cancelTapped];
}

- (void)saveTapped
{
    if ([self preparedForSave]) [self.delegate createTapped];
}

- (BOOL)preparedForSave { return YES; }

#pragma mark - Gesture Recognizer Methods

- (void)calendarCellTapped
{
    [self.delegate calendarCellTapped];
}

@end
