//
//  NewToDoView.h
//  SeniorProject
//
//  Created by Skylar Peterson on 2/10/14.
//  Copyright (c) 2014 SkylarPeterson. All rights reserved.
//

#import "AddView.h"
#import "ListItem.h"
#import "CalendarCell.h"

@interface NewTaskView : AddView

@property (nonatomic, strong) ListItem *listItem;

@property (nonatomic, strong, readonly) NSString *contents;
@property (nonatomic, readonly) NSInteger calendar;
@property (nonatomic, readonly) BOOL isMulti;
@property (nonatomic, strong, readonly) NSDate *dateToSee;
@property (nonatomic, strong, readonly) NSDate *dateDue;

@end
