//
//  DatePickerView.m
//  One
//
//  Created by Skylar Peterson on 3/2/14.
//  Copyright (c) 2014 SkylarPeterson. All rights reserved.
//

#import "DatePickerView.h"
#import "DatePickerCell.h"
#import "OptionsView.h"

#import "Fonts.h"
#import "Colors.h"
#import "CalInfo.h"

@interface DatePickerView()

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, readwrite) NSInteger monthNum;

@end

@implementation DatePickerView

#pragma mark - Initialization

- (id)initWithDate:(NSDate *)date
{
    self = [super init];
    if (self) {
        self.date = date;
        NSArray *dateComponents = [CalInfo dateComponentsForDate:self.date];
        self.monthNum = ((NSString *)[dateComponents objectAtIndex:0]).integerValue;
        self.options = [[CalInfo dateStringArrayForDate:self.date] mutableCopy];
        [self initialize];
    }
    return self;
}

#pragma mark - Collection View Data Source Methods

- (NSArray *)dataSourceForIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            return [CalInfo monthStrings];
            break;
        case 1:
            return [CalInfo dayStringsForMonth:self.monthNum inYear:((NSString *)[self.options objectAtIndex:2]).integerValue];
            break;
        case 2:
            return [CalInfo yearStringsStartingOnDate:[NSDate date] withNumStrings:12];
            break;
        default:
            return nil;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedIndex == 0 || self.selectedIndex == 2) {
        return CGSizeMake(self.collectionView.frame.size.width/3.0, self.collectionView.frame.size.height/4.0);
    } else if (self.selectedIndex == 1) {
        CGFloat divider = (self.collectionViewDataSource.count % 7 == 0) ? 4.0 : 5.0;
        return CGSizeMake(self.collectionView.frame.size.width/7.0, self.collectionView.frame.size.height/divider);
    } else {
        return CGSizeZero;
    }
}

#pragma mark - Collection View Delegate Methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedIndex == 0) self.monthNum = indexPath.row + 1;
    [super collectionView:collectionView didSelectItemAtIndexPath:indexPath];
}

@end
