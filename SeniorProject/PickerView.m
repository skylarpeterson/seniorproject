//
//  PickerView.m
//  One
//
//  Created by Skylar Peterson on 3/17/14.
//  Copyright (c) 2014 SkylarPeterson. All rights reserved.
//

#import "PickerView.h"
#import "OptionsView.h"
#import "DatePickerCell.h"
#import "Fonts.h"

@interface PickerView()<OptionsViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) OptionsView *optionsView;
@property (nonatomic) BOOL expanded;

@end

@implementation PickerView

#pragma mark - Setters

- (void)setMainColor:(UIColor *)mainColor
{
    _mainColor = mainColor;
    self.optionsView.unselectedColor = mainColor;
}

- (void)setSelectedColor:(UIColor *)selectedColor
{
    _selectedColor = selectedColor;
    self.backgroundColor = selectedColor;
    self.optionsView.backgroundColor = [UIColor clearColor];
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    self.optionsView.textColor = textColor;
}

#pragma mark - Initialization

- (void)initialize
{
    self.backgroundColor = [UIColor clearColor];
    self.autoresizesSubviews = NO;
    self.expanded = NO;
    self.selectedIndex = -1;
    
    self.optionsView = [[OptionsView alloc] init];
    self.optionsView.delegate = self;
    self.optionsView.options = [self.options copy];
    self.optionsView.selectedIndex = -1;
    
    [self addSubview:self.optionsView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.optionsView.frame = CGRectMake(0.0, 0.0, self.frame.size.width, PICKER_HEIGHT);
}

#pragma mark - Methods

#define CELL_IDENTIFER @"DatePickerCell"
- (void)finishedExpanding
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0, self.optionsView.frame.origin.y + self.optionsView.frame.size.height, self.frame.size.width, self.frame.size.height - self.optionsView.frame.size.height)
                                             collectionViewLayout:flowLayout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.alpha = 0.0;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[DatePickerCell class] forCellWithReuseIdentifier:CELL_IDENTIFER];
    [self addSubview:self.collectionView];
    [UIView animateWithDuration:0.35
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.collectionView.alpha = 1.0;
                     }completion:nil];
}

- (NSArray *)dataSourceForIndex:(NSInteger)index
{
    return nil;
}

#pragma mark - Collection View Data Source

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DatePickerCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFER forIndexPath:indexPath];
    
    cell.textLabel.text = [self.collectionViewDataSource objectAtIndex:indexPath.row];
    cell.textLabel.font = [Fonts optionsViewSelectedTabFont];
    cell.textLabel.textColor = self.textColor;
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.collectionViewDataSource count];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DatePickerCell *cell = (DatePickerCell *)[collectionView cellForItemAtIndexPath:indexPath];
    self.options[self.selectedIndex] = cell.textLabel.text;
    self.optionsView.options = self.options;
    if ([self.delegate respondsToSelector:@selector(pickerSelectionChanged)]) {
        [self.delegate pickerSelectionChanged];
    }
}

#pragma mark - Options View Delegate

- (void)selectedIndexChangedToIndex:(NSInteger)index
{
    if (!self.expanded) {
        self.expanded = YES;
        self.collectionViewDataSource = [self dataSourceForIndex:index];
        [self.delegate pickerExpanding:self];
    } else if (index != self.selectedIndex){
        self.collectionViewDataSource = [self dataSourceForIndex:index];
        [self.collectionView reloadData];
    } else {
        self.optionsView.selectedIndex = -1;
        self.expanded = NO;
        [UIView animateWithDuration:0.25
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.collectionView.alpha = 0.0;
                         }completion:^(BOOL finished){
                             if (finished) {
                                 [self.collectionView removeFromSuperview];
                                 [self.delegate pickerShrinking:self];
                             }
                         }];
    }
    self.selectedIndex = index;
}


@end
