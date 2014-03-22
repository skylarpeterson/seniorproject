//
//  OptionsView.h
//  SeniorProject
//
//  Created by Skylar Peterson on 2/10/14.
//  Copyright (c) 2014 SkylarPeterson. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OptionsViewDelegate <NSObject>

@required
- (void)selectedIndexChangedToIndex:(NSInteger)index;

@end

@interface OptionsView : UIView

@property (nonatomic, strong) id<OptionsViewDelegate> delegate;
@property (nonatomic, strong) NSArray *options;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *unselectedColor;
@property (nonatomic) NSInteger selectedIndex;

@end
