//
//  AddView.h
//  SeniorProject
//
//  Created by Skylar Peterson on 2/10/14.
//  Copyright (c) 2014 SkylarPeterson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarCell.h"

@protocol AddViewDelegate <NSObject>

@required
- (void)cancelTapped;
- (void)createTapped;
- (void)calendarCellTapped;

@end

@interface AddView : UIView

#define TITLE_LABEL_HEIGHT 50.0
#define MAIN_BUTTON_HEIGHT 65.0
#define DIVIDE_INSET 10.0

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) id<AddViewDelegate> delegate;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSString *titleText;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) CalendarCell *calendarCell;

- (UILabel *)labelWithText:(NSString *)text;
- (BOOL)preparedForSave;

@end
