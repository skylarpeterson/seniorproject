//
//  DatePickerCell.m
//  One
//
//  Created by Skylar Peterson on 3/3/14.
//  Copyright (c) 2014 SkylarPeterson. All rights reserved.
//

#import "DatePickerCell.h"
#import "Fonts.h"

@interface DatePickerCell()

@end

@implementation DatePickerCell

- (UILabel *)textLabel
{
    if(!_textLabel) _textLabel = [[UILabel alloc] init];
    return _textLabel;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.textLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height);
}

@end
