//
//  AddNewCell.m
//  One
//
//  Created by Skylar Peterson on 3/10/14.
//  Copyright (c) 2014 SkylarPeterson. All rights reserved.
//

#import "AddNewCell.h"

@interface AddNewCell()

@property (nonatomic, strong) UIButton *addButton;

@end

@implementation AddNewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.addButton = [[UIButton alloc] init];
        [self.addButton setBackgroundImage:[UIImage imageNamed:@"PlusLight.png"] forState:UIControlStateNormal];
        [self.addButton addTarget:self action:@selector(addTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.addButton];
    }
    return self;
}

#define BUTTON_SIZE 60.0
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.addButton.frame = CGRectMake(self.frame.size.width - BUTTON_SIZE, self.frame.size.height/2.0 - BUTTON_SIZE/2.0, BUTTON_SIZE, BUTTON_SIZE);
}

- (void)addTapped
{
    [self.delegate addButtonPressedForCell:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
