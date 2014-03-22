//
//  DatePickerView.h
//  One
//
//  Created by Skylar Peterson on 3/2/14.
//  Copyright (c) 2014 SkylarPeterson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickerView.h"

@interface DatePickerView : PickerView

@property (nonatomic, readonly) NSInteger monthNum;
- (id)initWithDate:(NSDate *)date;

@end
