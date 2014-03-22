//
//  RecurrencePicker.h
//  One
//
//  Created by Skylar Peterson on 3/18/14.
//  Copyright (c) 2014 SkylarPeterson. All rights reserved.
//

#import "BlurOverlayView.h"

@protocol RecurrencePickerDelegate <NSObject>

@required
- (void)recurrencePicked:(UITableViewCell *)cell;

@end

@interface RecurrencePicker : BlurOverlayView

@property (nonatomic, strong) id<RecurrencePickerDelegate> delegate;
@property (nonatomic) BOOL containsCustom;

@end
