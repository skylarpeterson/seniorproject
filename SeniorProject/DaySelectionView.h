//
//  DaySelectionView.h
//  SeniorProject
//
//  Created by Skylar Peterson on 1/27/14.
//  Copyright (c) 2014 SkylarPeterson. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DaySelectionViewDelegate <NSObject>

@optional
- (void)daySelectionViewPanningBegan;
- (void)daySelectionViewPanningChanged:(CGPoint)translation;
- (void)daySelectionViewPanningEnded;

@end

@interface DaySelectionView : UIView

@property (nonatomic, strong) id<DaySelectionViewDelegate> delegate;
@property (nonatomic, strong) NSArray *dates;
@property (nonatomic) NSInteger selectedIndex;

@end
