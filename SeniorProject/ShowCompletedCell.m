//
//  ShowCompletedCell.m
//  One
//
//  Created by Skylar Peterson on 3/12/14.
//  Copyright (c) 2014 SkylarPeterson. All rights reserved.
//

#import "ShowCompletedCell.h"

#import "Colors.h"
#import "Fonts.h"
#import "Methods.h"

@interface ShowCompletedCell()

@property (nonatomic, strong) UIButton *showCompletedButton;
@property (nonatomic) BOOL showing;

@end

@implementation ShowCompletedCell

- (void)setShowButton:(BOOL)showButton
{
    _showButton = showButton;
    if (!showButton) {
        self.showCompletedButton.alpha = 0.0;
        self.showCompletedButton.userInteractionEnabled = NO;
    } else {
        self.showCompletedButton.alpha = 1.0;
        self.showCompletedButton.userInteractionEnabled = YES;
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.showCompletedButton = [[UIButton alloc] init];
        [self.showCompletedButton setTitle:@"Show Completed" forState:UIControlStateNormal];
        [self.showCompletedButton setTitleColor:[Colors lightestGrayColor] forState:UIControlStateNormal];
        self.showCompletedButton.titleLabel.font = [Fonts showCompletedFont];
        [self.showCompletedButton addTarget:self action:@selector(showCompleted) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.showCompletedButton];
    }
    return self;
}

#define BUTTON_WIDTH 195.0
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.showCompletedButton.frame = CGRectMake(self.frame.size.width - BUTTON_WIDTH, 0.0, BUTTON_WIDTH, self.frame.size.height);
}

- (void)showCompleted
{
    if (self.showing) {
        [self.showCompletedButton setTitle:@"Show Completed" forState:UIControlStateNormal];
        self.showing = NO;
        [self.delegate hideCompletedTapped:self];
    } else {
        [self.showCompletedButton setTitle:@"Hide Completed" forState:UIControlStateNormal];
        self.showing = YES;
        [self.delegate showCompletedTapped:self];
    }
}

@end
