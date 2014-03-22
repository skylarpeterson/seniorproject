//
//  RecurrencePicker.m
//  One
//
//  Created by Skylar Peterson on 3/18/14.
//  Copyright (c) 2014 SkylarPeterson. All rights reserved.
//

#import "RecurrencePicker.h"
#import "Fonts.h"

@interface RecurrencePicker()

@property (nonatomic, strong) NSArray *recurrences;

@end

@implementation RecurrencePicker

#define CELL_IDENTIFIER @"CellIdentifier"

- (void)setContainsCustom:(BOOL)containsCustom
{
    _containsCustom = containsCustom;
    if (containsCustom) {
        self.recurrences = @[@"Never",
                             @"Every Day",
                             @"Every Week",
                             @"Every 2 Weeks",
                             @"Every Month",
                             @"Every Year",
                             @"Custom"];
    } else {
        self.recurrences = @[@"Never",
                             @"Every Day",
                             @"Every Week",
                             @"Every 2 Weeks",
                             @"Every Month",
                             @"Every Year"];
    }
}

- (void)initialize
{
    [super initialize];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CELL_IDENTIFIER];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

#pragma mark - Table View Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.recurrences count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [self.recurrences objectAtIndex:indexPath.row];
    cell.textLabel.textColor = self.textColor;
    cell.textLabel.font = [Fonts listItemFont];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate recurrencePicked:[self.tableView cellForRowAtIndexPath:indexPath]];
}

@end
