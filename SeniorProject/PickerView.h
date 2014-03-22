//
//  PickerView.h
//  One
//
//  Created by Skylar Peterson on 3/17/14.
//  Copyright (c) 2014 SkylarPeterson. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PickerDelegate <NSObject>

- (void)pickerExpanding:(UIView *)picker;
- (void)pickerShrinking:(UIView *)picker;
@optional
- (void)pickerSelectionChanged;

@end

@interface PickerView : UIView <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

#define PICKER_HEIGHT 50.0
@property (nonatomic, strong) id<PickerDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *options;
@property (nonatomic, strong) UIColor *mainColor;
@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *collectionViewDataSource;

- (void)initialize;
- (void)finishedExpanding;
- (NSArray *)dataSourceForIndex:(NSInteger)index;

@end
