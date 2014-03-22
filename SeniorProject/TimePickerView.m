//
//  TimePickerView.m
//  One
//
//  Created by Skylar Peterson on 3/17/14.
//  Copyright (c) 2014 SkylarPeterson. All rights reserved.
//

#import "TimePickerView.h"
#import "OptionsView.h"

@interface TimePickerView()

@property (nonatomic, strong) NSString *time;

@end

@implementation TimePickerView

#pragma mark - Initialization

- (id)initWithTime:(NSString *)time
{
    self = [super init];
    if (self) {
        self.time = time;
        NSInteger firstIndex = ([time characterAtIndex:1] == ':') ? 1 : 2;
        self.options = [@[[time substringToIndex:firstIndex], [time substringWithRange:NSMakeRange(firstIndex + 1, 2)], [time substringFromIndex:firstIndex + 3]] mutableCopy];
        [self initialize];
    }
    return self;
}

#pragma mark - Collection View Data Source Methods

- (NSArray *)dataSourceForIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            return @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12"];
            break;
        case 1:
            return @[@"00", @"05", @"10", @"15", @"20", @"25", @"30", @"35", @"40", @"45", @"50", @"55"];
            break;
        case 2:
            return @[@"AM", @"PM"];
            break;
        default:
            return nil;
            break;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedIndex == 0 || self.selectedIndex == 1) {
        return CGSizeMake(self.collectionView.frame.size.width/4.0, self.collectionView.frame.size.height/3.0);
    } else if (self.selectedIndex == 2) {
        return CGSizeMake(self.collectionView.frame.size.width/2.0, self.collectionView.frame.size.height);
    }
    return CGSizeZero;
}

@end
