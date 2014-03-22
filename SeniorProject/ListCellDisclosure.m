//
//  ListCellDisclosure.m
//  One
//
//  Created by Skylar Peterson on 3/6/14.
//  Copyright (c) 2014 SkylarPeterson. All rights reserved.
//

#import "ListCellDisclosure.h"
#import "ListCell.h"
#import "Colors.h"
#import "Fonts.h"

@interface ListCellDisclosure()

@property (nonatomic, strong) UIButton *disclosureButton;

@end

@implementation ListCellDisclosure

#define COMPLETE_VIEW_SIZE 60.0
#define TEXT_VIEW_INSET 10.0

#pragma mark - Initializing Methods

- (void)setDisclosed:(BOOL)disclosed
{
    _disclosed = disclosed;
    if (disclosed) {
        self.disclosureButton.transform = CGAffineTransformMakeRotation(90.0*M_PI/180.0);
        [self.disclosureButton setBackgroundImage:[UIImage imageNamed:@"DisclosureLight.png"] forState:UIControlStateNormal];
    } else {
        self.disclosureButton.transform = CGAffineTransformMakeRotation(0.0*M_PI/180.0);
        [self.disclosureButton setBackgroundImage:[UIImage imageNamed:@"DisclosureDark.png"] forState:UIControlStateNormal];
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.disclosureButton = [[UIButton alloc] init];
        [self.disclosureButton setBackgroundImage:[UIImage imageNamed:@"DisclosureDark.png"] forState:UIControlStateNormal];
        [self.disclosureButton addTarget:self action:@selector(disclose) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.disclosureButton];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize textViewSize = [ListCell sizeForTextViewWithText:self.textView.attributedText inCellWidth:self.frame.size.width - 2*TEXT_VIEW_INSET - COMPLETE_VIEW_SIZE];
    self.disclosureButton.frame = CGRectMake(2*TEXT_VIEW_INSET + textViewSize.width, self.frame.size.height/2.0 - COMPLETE_VIEW_SIZE/2.0, COMPLETE_VIEW_SIZE, COMPLETE_VIEW_SIZE);
    self.textView.frame = CGRectMake(TEXT_VIEW_INSET, self.frame.size.height / 2.0 - textViewSize.height / 2.0, textViewSize.width, textViewSize.height);
}

- (void)disclose
{
    if (self.disclosed) {
        [UIView animateWithDuration:0.25
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.disclosureButton.transform = CGAffineTransformMakeRotation(0.0*M_PI/180.0);
                             [self.disclosureButton setBackgroundImage:[UIImage imageNamed:@"DisclosureDark.png"] forState:UIControlStateNormal];
                         }completion:^(BOOL finished){
                             [self.disclosureDelegate listCellClosed:self];
                         }];
    } else {
        [UIView animateWithDuration:0.25
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.disclosureButton.transform = CGAffineTransformMakeRotation(90.0*M_PI/180.0);
                             [self.disclosureButton setBackgroundImage:[UIImage imageNamed:@"DisclosureLight.png"] forState:UIControlStateNormal];
                         }completion:^(BOOL finished){
                             [self.disclosureDelegate listCellDisclosed:self];
                         }];
    }
}

@end
