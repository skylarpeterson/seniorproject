//
//  BlurOverlayView.m
//  One
//
//  Created by Skylar Peterson on 3/18/14.
//  Copyright (c) 2014 SkylarPeterson. All rights reserved.
//

#import "BlurOverlayView.h"
#import "Colors.h"

@implementation BlurOverlayView

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    if ([textColor isEqual:[Colors mainGrayColor]]) {
        self.tintColor = [Colors secondarGrayColor];
    } else {
        self.tintColor = [Colors lightestGrayColor];
    }
}

- (void)initialize
{
    self.blurRadius = 20.0;
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorColor = [Colors secondarGrayColor];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.layer.borderColor = [[Colors secondarGrayColor] CGColor];
    self.tableView.layer.borderWidth = 1.0;
    self.tableView.layer.cornerRadius = 10.0;
    
    [self addSubview:self.tableView];
}

#define CAL_INSET 10.0
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.tableView.frame = CGRectMake(CAL_INSET, 20.0 + CAL_INSET, self.frame.size.width - 2*CAL_INSET, self.frame.size.height - 20.0 - 2*CAL_INSET);
}

#pragma mark - Table View Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end
